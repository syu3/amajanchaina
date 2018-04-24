//
//  WebView.swift
//  amajanChaina
//
//  Created by 加藤健一 on 2018/04/21.
//  Copyright © 2018年 加藤健一. All rights reserved.
//

import UIKit
import WebKit
class WebView: UIViewController {
    var barcodeV = ""
    //    var segmentV = ""
    var targetURL = ""
    @IBOutlet var webView : UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(barcodeV)
        targetURL = "https://www.amazon.cn/s/ref=nb_sb_noss?__mk_zh_CN=%E4%BA%9A%E9%A9%AC%E9%80%8A%E7%BD%91%E7%AB%99&url=search-alias%3Daps&field-keywords="+barcodeV
        print(targetURL)
        let requestURL = URL(string: targetURL)
        let req = URLRequest(url: requestURL!)
        webView.loadRequest(req)
        
        //        }else if(segmentV == "Rakuten"){
        //            print(segmentV)
        //            targetURL = "http://search.rakuten.co.jp/search/mall/"+barcodeV
        //            //            targetURL = "http://hb.afl.rakuten.co.jp/hgc/14c3f1c8.91f200d6.14c3f1c9.d9e82867/?pc=http%3a%2f%2fsearch.rakuten.co.jp%2fsearch%2fmall%2f1234567890%2f%3fscid%3daf_link_urltxt&amp;m=http%3a%2f%2fm.rakuten.co.jp%2f"
        //            let requestURL = URL(string: targetURL)
        //            let req = URLRequest(url: requestURL!)
        //            webView.loadRequest(req)
        //
        //        }else if(segmentV == "Yahoo"){
        //            print(segmentV)
        //            targetURL = "http://search.shopping.yahoo.co.jp/search?p="+barcodeV+"&type=all&tab_ex=commerce&fr=shp-prop&first=1&cid=&sc_i=shp_sp_top_searchBox&mcr=417375c1860371c9e9bfa930806b105e&ts=1456134555"
        //            let requestURL = URL(string: targetURL)
        //            let req = URLRequest(url: requestURL!)
        //            webView.loadRequest(req)
        //        }else if(segmentV == "Kakaku"){
        //            print(segmentV)
        //            targetURL = "http://s.kakaku.com/search_results/?query="+barcodeV
        //            let requestURL = URL(string: targetURL)
        //            let req = URLRequest(url: requestURL!)
        //            webView.loadRequest(req)
        //            print(req)
        //        }else{
        //            print(segmentV)
        //            targetURL = "https://www.amazon.cn/s/ref=nb_sb_noss?__mk_zh_CN=%E4%BA%9A%E9%A9%AC%E9%80%8A%E7%BD%91%E7%AB%99&url=search-alias%3Daps&field-keywords="+barcodeV
        //            let requestURL = URL(string: targetURL)
        //            let req = URLRequest(url: requestURL!)
        //            webView.loadRequest(req)
        //        }
        //
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func review(){
        performSegue(withIdentifier: "review", sender: nil)
    }
    
    
    //    func webViewDidStartLoad(webView: UIWebView) {
    //        print("webViewDidStartLoad")
    //    }
    //    func webViewDidFinishLoad(webView: UIWebView) {
    //        print("webViewDidFinishLoad")
    //    }
    
    

    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
