//
//  PostsEntireViewController.swift
//  CiudadInvisible
//
//  Created by Mathias on 05/07/14.
//  Copyright (c) 2014 CiudadInvisible. All rights reserved.
//

import UIKit
import MapKit

class PostsDetailViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var post : Post! = nil
    
    var portadaPostView : PostView = PostView()
    var backgroundImage = UIImageView()
    var imageEmpty : UIImage = UIImage(named: "bgEmpty.jpg")
    
    @IBOutlet var tableView : UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loadTableViewHeader()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: TableView
    
    func loadTableViewHeader() {
        //self.tableView.tableHeaderView = PostView(frame: view.frame, image: UIImage(named: "bg1.jpg"), name: "La Marilyn", distance: "500 m")
        
        tableView.backgroundColor = UIColor.clearColor()
        
        // Agrego la imagen en el fondo del header
        backgroundImage.frame = self.view.frame
        if post.images.count > 0 {
            // Si tiene imagen la carga
            let images = post.imagesLarge()
            backgroundImage.setImageWithURL(NSURL(string: images.objectAtIndex(0) as String), placeholderImage: self.imageEmpty)
        }
        self.view.insertSubview(backgroundImage, belowSubview: tableView)
        
        // Configuro el header
        var headerView : UIView = UIView(frame: view.frame)
        headerView.backgroundColor = UIColor.clearColor()
        
        var postName = UILabel(frame: CGRect(x: 20, y: view.frame.height-100, width: view.frame.width - 20, height: 80))
        postName.text = post.title
        postName.font = UIFont(name: "Helvetica", size: 35)
        postName.textColor = UIColor.whiteColor()
        headerView.addSubview(postName)
 /*
        var postAuthor = UILabel(frame: CGRect(x: 20, y: view.frame.height-40, width: view.frame.width - 40, height: 20))
        postAuthor.text = post.author
        postAuthor.font = UIFont(name: "Helvetica", size: 14)
        postAuthor.textColor = UIColor.whiteColor()
        postAuthor.textAlignment = NSTextAlignment.Right
        headerView.addSubview(postAuthor)
*/
        
        // Avatar
        var avatar = UIImageView(image: UserSesionHelper.sharedInstance().getUserLogued().avatar())
        avatar.center = CGPointMake(230, 400)
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
        avatar.transform = CGAffineTransformMakeScale(0.4, 0.4)
        headerView.addSubview(avatar)
        
        
        var backButton = UIButton(frame: CGRect(x: 20, y: 20, width: 30, height: 30))
        backButton.backgroundColor = UIColor.darkGrayColor()
        //backButton.titleLabel.font = UIFont(name: "Helvetica", size: 35)
        backButton.setTitle("<", forState: .Normal)
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.addTarget(self, action: Selector("volver:"), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(backButton)
        
        // Favorito
/*
        var favButton = UIButton(frame: CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50, 30, 30))
        favButton.setTitle("Fav", forState: .Normal)
        favButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        favButton.addTarget(self, action: "favorite:", forControlEvents: .TouchUpInside)
        headerView.addSubview(favButton)
*/
        // Flecha
        var flechaView = UIImageView(image: HelperForms.imageOfFlecha)
        flechaView.center = CGPointMake(headerView.center.x, headerView.frame.size.height - 20)
        headerView.addSubview(flechaView)
        
        self.tableView.tableHeaderView = headerView
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell! = nil
        
        
        if (indexPath.row == 0) {
            // Imagenes
            cell = tableView.dequeueReusableCellWithIdentifier("PostImagesCell", forIndexPath: indexPath) as UITableViewCell
            
        } else if (indexPath.row == 1) {
            // Descripcion
            cell = tableView.dequeueReusableCellWithIdentifier("PostDescriptionCell", forIndexPath: indexPath) as PostDetailDescriptionCell
            // Configuro los valores
            (cell as PostDetailDescriptionCell).descriptionText.text = post.descriptionText
            (cell as PostDetailDescriptionCell).categoryText.text = post.category
            
        } else if (indexPath.row == 2) {
            // Mapa
            cell = tableView.dequeueReusableCellWithIdentifier("PostMapCell", forIndexPath: indexPath) as PostDetailMapCell
            // Configuracion del mapa
            var mapa : MKMapView = (cell as PostDetailMapCell).mapa
            let coordinate = self.post.coordinate()
            MapHelper.centerMap(mapa, coordinate: coordinate, distance: 1000)
            MapHelper.addAnotationToMap(mapa, coordinate: coordinate, title: post.title)
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if (indexPath.row == 0) {
            // Imagenes
            return 141
        } else if (indexPath.row == 1) {
            // Descripcion
            return 200
        } else if (indexPath.row == 2) {
            // Mapa
            return 141
        } else {
            return 141
        }
    }
    
    // MARK: ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        
        let scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset < 0) {
            // Adjust image proportionally
            let escala = 1 - scrollOffset / 700
            backgroundImage.transform = CGAffineTransformMakeScale(escala, escala)
            
            //tableView.tableHeaderView.backgroundColor = UIColor.clearColor()
            tableView.tableHeaderView?.backgroundColor = UIColor.clearColor()
            //backgroundImage.image.applyBlurWithRadius(0, tintColor: nil, saturationDeltaFactor: 1, maskImage: nil)
            
        } else {
            // We're scrolling up, return to normal behavior
            backgroundImage.transform = CGAffineTransformIdentity
            
            let blur = scrollOffset / 700
            
            tableView.tableHeaderView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: blur)
            
            //backgroundImage.setImageToBlur(UIImage(named: "bg1.jpg"), blurRadius: blur, completionBlock: nil)
            
        }
        
    }
    
    // MARK: UICollectionViewDataSource - Images
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        return self.post.images.count - 1 // Le saca la principal
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
    {
        var cell : PostImagesCell = collectionView.dequeueReusableCellWithReuseIdentifier("PostImageCell", forIndexPath: indexPath) as PostImagesCell
        
        // Configuro la celda, al indexPath le suma uno porque la primera no se considera
        let images = post.imagesSmall()
        cell.image.setImageWithURL(NSURL(string: images.objectAtIndex(indexPath.row + 1) as String), placeholderImage: self.imageEmpty)
        
        return cell
    }
    
    // MARK: Actions
    func volver(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func favorite(sender: AnyObject) {
        RestApiHelper.sharedInstance().favoritePost(self.post.id, userId: UserSesionHelper.sharedInstance().getUserLogued().id)
            { (success) -> () in
            
        }
    }

}
