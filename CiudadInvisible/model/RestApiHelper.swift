//
//  RestApiHelper.swift
//  CiudadInvisible
//
//  Created by Mathias on 05/07/14.
//  Copyright (c) 2014 CiudadInvisible. All rights reserved.
//

class RestApiHelper: NSObject {

    let manager = AFHTTPRequestOperationManager()
    
    // MARK: Singleton
    class func sharedInstance() -> RestApiHelper! {
        struct Static {
            static var instance: RestApiHelper? = nil
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = self()
        }
        return Static.instance!
    }
    
    @required init() {
        
    }
    
    // MARK: Private methods
    func getPosts() {
        
        /*
        manager.GET("http://ciudadinvisible.herokuapp.com/posts.json",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Json obtenido => " + responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("Error")
            })
        */
    }
    
    func getPostsSlider() -> NSArray {
        let post1 = Post(titulo: "El cierre", distancia: "400 m", imagen: UIImage(named: "bg1.jpg"))
        let post2 = Post(titulo: "La marilyn", distancia: "500 m", imagen: UIImage(named: "bg2.jpg"))
        let post3 = Post(titulo: "La plaza", distancia: "700 m", imagen: UIImage(named: "bg3.jpg"))
        
        return [post1, post2, post3]
    }
}