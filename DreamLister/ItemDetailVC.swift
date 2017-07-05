//
//  ItemDetailVC.swift
//  DreamLister
//
//  Created by Reggie on 6/27/17.
//  Copyright © 2017 Reggie. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var detailField: CustomTextField!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        self.detailField.delegate = self
        self.priceField.delegate = self
        self.titleField.delegate = self
        
        
        getStores()

        if stores.count < 6 {
        
            let store = Store(context: context)
            store.name = "Best Buy"
            let store2 = Store(context: context)
            store2.name = "Tesla Dealership"
            let store3 = Store(context: context)
            store3.name = "Fry's"
            let store4 = Store(context: context)
            store4.name = "Target"
            let store5 = Store(context: context)
            store5.name = "Amazon"
            let store6 = Store(context: context)
            store6.name = "K-Mart"
        
            ad.saveContext()
            getStores()

        }
        
        if itemToEdit != nil{
            loadItemData()
        }
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update pickerView
    }
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            print("No stores loaded")
            //handle the error
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        var item: Item!
        
        //create image entity
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
       
        //handles if we are editing an item
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toimage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details = detailField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailField.text = item.details
            
            thumbImg.image = item.toimage?.image as? UIImage
            
            if let store = item.toStore{
                
                var index = 0
                
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index+=1
                } while (index < stores.count)
                
            }
        }
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
       present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        

        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumbImg.image = img
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    
    
}

