//
//  MenuViewController.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 11/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let colorPrimary = UIColor.init(named: "colorPrimary")

class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{
  
    
    
    var mCategories = Set<Category>()
    var mProducts : Array<Product>?
    var mTableSource = [ Category : Array<Product>]()
    
    var menuView : MenuView?
    let headerViewMaxHeight: CGFloat = 250
    var headerViewMinHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView?.mTableView.delegate = self
        menuView?.mTableView.dataSource = self
        
        self.menuView?.mTableView.register(UINib.init(nibName: "ProductTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "t")
        headerViewMinHeight = 0//UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height
        
        self.menuView?.mCollectionView.delegate = self
        self.menuView?.mCollectionView.dataSource = self
    //    self.menuView?.mCollectionView.scro
        //estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        
        self.menuView?.mCollectionView.register(UINib.init(nibName: "CategoryCell", bundle: Bundle.main), forCellWithReuseIdentifier: "t")
        
        if let flowLayout =  self.menuView?.mCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .horizontal
         }
       
        let gr = UIPanGestureRecognizer.init(target: self, action: #selector(self.panPiece(_:)))
        let grImage = UIPanGestureRecognizer.init(target: self, action: #selector(self.panPiece(_:)))
        gr.delegate = self
        self.menuView?.mImageView.addGestureRecognizer(grImage)
        self.menuView?.mCollectionView.addGestureRecognizer(gr)
        
        self.menuView?.mTableView.estimatedRowHeight = 250
        self.menuView?.mTableView.rowHeight = UITableView.automaticDimension
        
        let worker = ProductWorker()
        worker.header(handler: self.handleHeaderData(response:))
        worker.categories(handler: self.handleCategories(response:))
        
    //    let ud = UserDefaults.init(suiteName: PRODUCT_Q)
        let domain = Bundle.main.bundleIdentifier!
        prefs?.removePersistentDomain(forName: domain)
        prefs?.synchronize()
        
        self.navigationController?.navigationBar.layer.zPosition = -1;
        
        self.menuView?.mCartButton.addTarget(self, action: #selector(self.toCart), for: .touchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        if let view = Bundle.main.loadNibNamed("MainView", owner: self, options: nil)?[0] as? MenuView{
            self.view = view
            self.menuView = view
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   /*   let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 65))
        imageView.contentMode = .scaleAspectFit

      let image = UIImage(named: "resources_logo")
      imageView.image = image

      navigationItem.titleView = imageView
        imageView.clipsToBounds = false
        imageView.superview?.clipsToBounds = false
        navigationItem.titleView?.clipsToBounds = false
 */
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        var visibleRows,selectedItems : [IndexPath]?
        visibleRows = self.menuView?.mTableView.indexPathsForVisibleRows
        selectedItems = self.menuView?.mCollectionView.indexPathsForSelectedItems
        coordinator.animate(alongsideTransition: { context in
                // Save the visible row position
            
            
                context.viewController(forKey: UITransitionContextViewControllerKey.from)
            }, completion: { context in
                // Scroll to the saved position prior to screen rotate
                if let visibleRows = visibleRows{
                self.menuView?.mTableView.scrollToRow(at: visibleRows[0], at: .top, animated: false)
                }
               if let selectedItems = selectedItems{
                    self.menuView?.mCollectionView.scrollToItem(at: selectedItems[0], at: .centeredHorizontally, animated: false)
                }
                })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toCart"{
            let controller = segue.destination as? ShoppingCartViewController
            var list = Array<Product>()
            guard let products = self.mProducts else { return }
            for product in products{
                let q = prefs?.integer(forKey: PRODUCT_Q + String.init(describing: product.id)) ?? 0
                if q > 0{
                    list.append(product)
                }
            }
            controller?.mProducts = list
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mTableSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = self.mTableSource.keys.sorted()[section]
        guard let array = self.mTableSource[category] else { return 0 }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "t") as! ProductTableViewCell
        let category = self.mTableSource.keys.sorted()[indexPath.section]
        if let array = self.mTableSource[category]  {
            cell.product = array[indexPath.row]
        }
        cell.setNeedsUpdateConstraints()
        cell.updateConstraints()
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("MenuCategoryHeader", owner: tableView, options: nil)![0] as! UIView
        let category = self.mTableSource.keys.sorted()[section]
        let label = view.viewWithTag(1) as! UILabel
        if let name = category.name{
            label.attributedText = NSAttributedString.init(string: name)
            Utils.setup(label: label)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let productCell = cell as? ProductTableViewCell else { return }
        guard let category = productCell.product?.category else { return }
        guard let index = self.mCategories.sorted().firstIndex(of: category) else { return }
       
        guard let collectionView = self.menuView?.mCollectionView else { return }
        
        if let cell = collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) {
              let label = cell.viewWithTag(4)
            label?.backgroundColor = UIColor.init(named: "darkAccent")
            cell.contentView.viewWithTag(1)?.backgroundColor = UIColor.init(hexString: "03DAC5", alpha: 1.0)
        }
        
        guard let selectedIndex = self.menuView?.mCollectionView.indexPathsForSelectedItems?.first else { return }
      //  self.collectionView(collectionView, didSelectItemAt: IndexPath.init(row: index, section: 0))
        self.collectionView(collectionView, didDeselectItemAt: selectedIndex)
        if let cell = collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) {
              let label = cell.viewWithTag(4)
                      label?.backgroundColor = UIColor.init(named: "darkAccent")
            cell.contentView.viewWithTag(1)?.backgroundColor = UIColor.init(hexString: "03DAC5", alpha: 1.0)
        }
        
         self.menuView?.mCollectionView.selectItem(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let menuView = self.menuView else { return }
        guard let headerViewMinHeight = self.headerViewMinHeight else { return }
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = menuView.mHeaderHeight.constant - y
        
        if newHeaderViewHeight > headerViewMaxHeight {
            menuView.mHeaderHeight.constant = headerViewMaxHeight
        } else if newHeaderViewHeight < headerViewMinHeight {
            menuView.mHeaderHeight.constant = headerViewMinHeight
        } else {
            menuView.mHeaderHeight.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0 // block scroll view
            let wholeDelta = headerViewMaxHeight - headerViewMinHeight
            let currentDelta = newHeaderViewHeight - headerViewMinHeight
            self.menuView?.mImageView.alpha =  currentDelta / wholeDelta
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mCategories.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "t", for: indexPath)
        let label = cell.viewWithTag(2) as! UILabel
        if let name = self.mCategories.sorted()[indexPath.row].name{
            
            label.attributedText = NSAttributedString.init(string: name)
            if let attributedTitle = label.attributedText {
                let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
                mutableAttributedTitle.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedTitle.length))
                mutableAttributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedTitle.length))
               label.attributedText = mutableAttributedTitle
            }
        
        }
        let view = cell.viewWithTag(4) as! UIView
         view.backgroundColor = UIColor.init(hexString: "ffffff", alpha: 0.0)
        view.clipsToBounds = true;
        view.layer.cornerRadius = view.frame.size.height/2;
       // cell.contentView.backgroundColor = UIColor.init(hexString: "076f0e")
        cell.contentView.viewWithTag(1)?.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        return cell
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewCell {
              let label = cell.viewWithTag(4)
            label?.backgroundColor = UIColor.init(named: "darkAccent")
            cell.contentView.viewWithTag(1)?.backgroundColor = UIColor.init(hexString: "03DAC5", alpha: 1.0)
        }
        let c = self.mCategories.sorted()[indexPath.row]
        if let index = self.mTableSource.keys.sorted().firstIndex(of: c){
            self.menuView?.mTableView.scrollToRow(at: IndexPath.init(row: NSNotFound, section: index), at: .top, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewCell {
             let label = cell.viewWithTag(4)
            label?.backgroundColor = UIColor.init(hexString: "ffffff", alpha: 0.0)
            cell.contentView.viewWithTag(1)?.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        }
            
        
    }
    
    @objc func toCart(){
        performSegue(withIdentifier: "toCart", sender: nil)
    }
    
    @objc func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard let menuView = self.menuView else { return }
        guard let headerViewMinHeight = self.headerViewMinHeight else { return }
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let y = gestureRecognizer.velocity(in: menuView.mImageView).y > 0 ?
            (translation.y >= 0 ? -translation.y/20 : translation.y/20):
            (translation.y >= 0 ? translation.y/20 : -translation.y/20)
        if gestureRecognizer.state == .changed {
         //   print("changed \(gestureRecognizer.velocity(in: menuView.mImageView).y); translation:\(translation.y)")
        }
            
            let newHeaderViewHeight: CGFloat = menuView.mHeaderHeight.constant - y
            
            if newHeaderViewHeight > headerViewMaxHeight {
                menuView.mHeaderHeight.constant = headerViewMaxHeight
            } else if newHeaderViewHeight < headerViewMinHeight {
                menuView.mHeaderHeight.constant = headerViewMinHeight
            } else {
                menuView.mHeaderHeight.constant = newHeaderViewHeight
        //        scrollView.contentOffset.y = 0 // block scroll view
                let wholeDelta = headerViewMaxHeight - headerViewMinHeight
                let currentDelta = newHeaderViewHeight - headerViewMinHeight
                self.menuView?.mImageView.alpha =  currentDelta / wholeDelta
            }
            
     //   }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleHeaderData(response: AFDataResponse<Any>){
        switch response.result {
                   case let .success(value):
                      
                       if let json =  value as? [String: Any] {
                       print("JSON: \(json)") // serialized json response
                           let dict = NSDictionary.init(dictionary: json)
                            let model = MenuHeaderData.init(dictionary: dict)
                        if let url = model?.header?.first?.src{
                            AF.request(url, method: .get).response{response in
                                switch response.result {
                                case let .success(value):
                                    guard let data = value else { break }
                                    self.menuView?.mImageView.image = UIImage.init(data: data, scale: 1)
                                    break
                                case let .failure(error):
                                                        // Handle the error, a 404 for example.
                                    print(error)
                                    break
                                }
                            }
                        }
                           
                       }
                   
                       break
                   case let .failure(error):
                      // Handle the error, a 404 for example.
                       print(error)
                       break
                   }
    }
    
    func handleProducts(response: AFDataResponse<Any>){
        switch response.result {
                        case let .success(value):
                            if let json =  value as? [String: Any] {
                                            print("JSON: \(json)") // serialized json response
                                            let dict = NSDictionary.init(dictionary: json)
                                            let model = JSendArrayResponse<Product>.init(dictionary: dict)
                                guard var products = model?.data else { return  }
                                
                                var orphanProducts = Set<Product>()
                                var orphanCategories = Set<Category>()
                                
                                let cats = self.mCategories
                                
                                for item in products{
                                    var c: Category? = nil
                                      for category in self.mCategories{
                                        if let catId = item.categories?.first, catId == category.id{
                                            item.category = category
                                            c = category
                                            break
                                        }
                                        
                                        }
                                    guard let _ = c else {
                                        orphanProducts.insert(item)
                                        continue
                                    }
                                }
                                
                                orphanProducts.forEach{
                                                    guard let index = products.firstIndex(of: $0) else { return }
                                                    products.remove(at: index)
                                }
                                
                                b: for c in self.mCategories{
                                    
                                        for item in products{
                                            if let catId = item.categories?.first, catId == c.id{
                                                continue b
                                            }
                                        }
                                    orphanCategories.insert(c)
                                }
                                
                                orphanCategories.forEach{
                                    self.mCategories.remove($0)
                                }
                                
                                
                                DispatchQueue.main.async {
                                    self.menuView?.mCollectionView.reloadData()
                                    
                                }
                                
                                self.mCategories.forEach{
                                    self.mTableSource[$0] = Array<Product>()
                                }
                                
                                self.mProducts = products.sorted()
                                products.forEach{
                                    guard let category = $0.category else { return }
                                    self.mTableSource[category]?.append($0)
                                }
                                
                                mTableSource.forEach{ (arg) in
                                    
                                    var (_, value) = arg
                                    value.sort()
                                }
                               
                                DispatchQueue.main.async {
                                    self.menuView?.mTableView.reloadData()
                                }
                            }
                            break
                        case let .failure(error):
                               // Handle the error, a 404 for example.
                                print(error)
                            break
                            }
    }
    
    func handleCategories(response: AFDataResponse<Any>){
        switch response.result {
        case let .success(value):
            if let json =  value as? [String: Any] {
                                print("JSON: \(json)") // serialized json response
                                    let dict = NSDictionary.init(dictionary: json)
                                    let model = JSendArrayResponse<Category>.init(dictionary: dict)
                guard   let categories = model?.data else{
                    return
                }
                
                for c in categories{
                    if let index = categories.firstIndex(of: c){
                        c.order = index
                    }
                }
                
                categories.forEach{
                    self.mCategories.insert($0)
                }
                ProductWorker().products(handler: self.handleProducts(response:))
            }
            break
        case let .failure(error):
               // Handle the error, a 404 for example.
                print(error)
            break
            }
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
