//
//  ViewController.swift
//  ImagePicker
//
//  Created by Duc Nguyen on 6/28/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	
	var url: NSURL?
	let imagePicker = UIImagePickerController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imagePicker.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	@IBAction func actionSelectImage(sender: AnyObject) {
		switch sender.tag {
		case 1:
			pickAnImageFromLibrary()
			break
		case 2:
			loadFromExistingData()
			break
		case 3:
			imageView.image = nil
			break
		default:
			print("blah")
		}
		
	}
	
	func pickAnImageFromLibrary() {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func loadFromExistingData() {
		if url == nil {
			showMessage("Please select an image first!!!")
			return
		}
		let asset = PHAsset.fetchAssetsWithALAssetURLs([url!], options: nil)
		guard let result = asset.firstObject where result is PHAsset else {
			return
		}
		
		let imageManager = PHImageManager.defaultManager()
		imageManager.requestImageForAsset(result as! PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: PHImageContentMode.AspectFill, options: nil) { (image, dict) -> Void in
			if let image = image {
				self.imageView.image = image
			}
		}
	}
	
	func showMessage(message: String?) {
		let alert = UIAlertController(title: "Note", message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { Void in self.pickAnImageFromLibrary() }))
		self.presentViewController(alert, animated: true, completion: nil)
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			imageView.contentMode = .ScaleAspectFit
			imageView.image = pickedImage
		}
		if let url = info[UIImagePickerControllerReferenceURL] as? NSURL {
			print(url)
			self.url = url
		}
		
		dismissViewControllerAnimated(true, completion: nil)
	}
}
