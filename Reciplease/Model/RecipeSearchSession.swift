//
//  RecipeSearchSession.swift
//  Reciplease
//
//  Created by Maxime on 07/01/2021.
//  Copyright © 2021 Maxime. All rights reserved.
//

import Foundation
import Alamofire

protocol AlamofireSessions {
    func request(url:URL,callback:@escaping(AFDataResponse<Any>) -> Void)
}

final class RecipeSearchSession:AlamofireSessions{
    func request(url: URL, callback:@escaping(AFDataResponse<Any>)->Void)
    { AF.request(url).responseJSON { DataResponse
        in
        callback(DataResponse)
    }
    
    
    }
    
}
