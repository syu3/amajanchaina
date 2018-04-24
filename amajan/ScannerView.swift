//
//  ScannerView.swift
//  amajanChaina
//
//  Created by 加藤健一 on 2018/04/21.
//  Copyright © 2018年 加藤健一. All rights reserved.
//
//
//  scannerView.swift
//  amajanChaina
//
//  Created by 加藤健一 on 2018/04/21.
//  Copyright © 2018年 加藤健一. All rights reserved.
//

import UIKit
import AVFoundation
import JavaScriptCore
import CryptoSwift

extension Date {
    func jpDate(_ format: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func urlAWSQueryEncoding() -> String {
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: "-")
        if let ret = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters ) {
            return ret
        }
        return ""
    }

    func hmac(key: String) -> String {
        guard let keyBytes = key.data(using: .utf8)?.bytes, let mesBytes = self.data(using: .utf8)?.bytes else {
            return ""
        }
        let hmac = try! HMAC(key: keyBytes, variant: .sha256).authenticate(mesBytes)
        return Data(bytes: hmac).base64EncodedString()
    }
}
class ScannerView: UIViewController, AVCaptureMetadataOutputObjectsDelegate,XMLParserDelegate {
    var barcode = ""
    /// Object that coordinate the flow of data from AV input devices to outputs.
    let session : AVCaptureSession = AVCaptureSession()
    let session1 : AVCaptureSession = AVCaptureSession()
    @IBOutlet var cameraView: UIView!
    @IBOutlet var barCodeType: UILabel!
    @IBOutlet var barCodeString: UILabel!
    @IBOutlet var mySwitch : UISwitch!
    //    @IBOutlet var mySegment : UISegmentedControl!
    var device : AVCaptureDevice!
    @IBOutlet var keyWordField : UITextField!
    var segment = ""
    var key = 0
    var error : NSError!
    var afiriOk = ""
    //    let context = JSContext()
    //    let session1 : AVCaptureSession = AVCaptureSession()
    //    var input1:AVCaptureDeviceInput!
    //    var output1:AVCaptureStillImageOutput!
    //    var session:AVCaptureSession!
    //    var preView1:UIView!
    var camera1:AVCaptureDevice!
    @IBOutlet var cameraView1: UIView!
    var url = ""
    var xary = ["a","b"]
    override func viewDidLoad() {

        
        //        context.evaluateScript(<a href="http://ck.jp.ap.valuecommerce.com/servlet/referral?sid=3278814&pid=883910891&vc_url=http%3A%2F%2Fstore.shopping.yahoo.co.jp%2Fmiyanosoba%2Fstud-006.html" target="_blank" ><img src="http://ad.jp.ap.valuecommerce.com/servlet/gifbanner?sid=3278814&pid=883910891" height="1" width="0" border="0"><img src="http://www.my-kagawa.jp/udon/imgdata/img086_main.jpg" border="0"/></a>)
        
        
        super.viewDidLoad()
        // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
        mySwitch.addTarget(self, action: #selector(ScannerView.switchClick(_:)), for: UIControlEvents.valueChanged)
        //        mySegment.addTarget(self, action: #selector(ScannerView.segconChanged(_:)), for: UIControlEvents.valueChanged)
        
        //        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "camera:", userInfo: nil, repeats: true)
        //        do {
        
        //        }
        
        
        
        
        do{
            /// Capture input data from selected device.
            let input = try AVCaptureDeviceInput(device: AVCaptureDevice.default(for: .video)!)
            
            // Add a type of device that will capture the data.
            session.addInput(input)
        }catch let error as NSError{
            NSLog(error.description)
        }
        /// Intercepter of Metadata
        let outputMetadata = AVCaptureMetadataOutput()
        outputMetadata.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // Add metadata intercepter into the flow of data.
        session.addOutput(outputMetadata)
        // Capture all posible metadata.
        outputMetadata.metadataObjectTypes = outputMetadata.availableMetadataObjectTypes
        /// Captures video as it is being captured by an input device.
        let video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = cameraView.bounds
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // Add video layer into the current view.
        cameraView.layer.addSublayer(video)
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
        
        
        //        session1.startRunning()
        
        
        
        
        
        
    }
    
    // XMLを解析する
    func loadxml(){
        // 解析するXMLのURL
        //        let urlString = "https://news.yahoo.co.jp/pickup/entertainment/rss.xml"
        
        guard let url = NSURL(string: url) else{
            return
        }
        
        // インターネット上のXMLを取得し、NSXMLParserに読み込む
        guard let parser = XMLParser(contentsOf: url as URL) else{
            return
        }
        parser.delegate = self;
        parser.parse()
    }
    
    
    
    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        print("要素:" + string)
        xary.append(string)
        
        
    }
    
    // XML解析終了時に実行されるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
//        var vaArray : Array<String>!
        var vaArray:[String] = []
        print("終了")
        for (i, value) in xary.enumerated() {
//            print(value)
            var mae = value.prefix(2)
            if (mae == "B0"){
                print(xary[i])
                vaArray.append(xary[i])
                vaArray.append("+%7c+")
            }
        }
        barcode = vaArray.joined()
        print("barcodeは" + barcode)
//        barcode = xary[10] + " | " + xary[140] + " | " + xary[205] + " | " + xary[270] + " | " + xary[335] + " | " + xary[400]

        print(barcode)
        //        let index = xary.indexOf("London") // 2
    }
    
    
    // 解析中にエラーが発生した時に実行されるメソッド
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:" + parseError.localizedDescription)
    }
    //    func camera(){
    //        print("camera")
    //        for caputureDevice: AnyObject in AVCaptureDevice.devices() {
    //            // 背面カメラを取得
    //            if caputureDevice.position == AVCaptureDevicePosition.Back {
    //                camera1 = caputureDevice as? AVCaptureDevice
    //            }
    //            // 前面カメラを取得
    //            //if caputureDevice.position == AVCaptureDevicePosition.Front {
    //            //    camera = caputureDevice as? AVCaptureDevice
    //            //}
    //        }
    //
    //
    //
    //        // 入力をセッションに追加
    //        if(session1.canAddInput(input1)) {
    //            session1.addInput(input1)
    //        }
    //
    //        // 静止画出力のインスタンス生成
    //        output1 = AVCaptureStillImageOutput()
    //        // 出力をセッションに追加
    //        if(session.canAddOutput(output1)) {
    //            session.addOutput(output1)
    //        }
    //
    //        // セッションからプレビューを表示を
    //        let previewLayer = AVCaptureVideoPreviewLayer(session: session1)
    //
    //        previewLayer.frame = cameraView1.frame
    //
    //        //        previewLayer.videoGravity = AVLayerVideoGravityResize
    //        //        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
    //        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    //
    //        // レイヤーをViewに設定
    //        // これを外すとプレビューが無くなる、けれど撮影はできる
    //        self.view.layer.addSublayer(previewLayer)
    //    }
    //    internal func segconChanged(_ segment: UISegmentedControl){
    //
    //        switch segment.selectedSegmentIndex {
    //        case 0:
    //            self.segment = "Amazon"
    //            print(self.segment)
    //            break
    //        case 1:
    //            self.segment = "Rakuten"
    //            print(self.segment)
    //            break
    //        case 2:
    //            self.segment = "Yahoo"
    //            print(self.segment)
    //            break
    //        case 3:
    //            self.segment = "Kakaku"
    //            print(self.segment)
    //            break
    //        default:
    //            print("Error")
    //        }
    //    }
    @objc internal func switchClick(_ sender: UISwitch){
        
        do{
            //            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            let device = AVCaptureDevice.default(for: .video)
            
            if sender.isOn {
                print("on")
                //            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
                try device?.lockForConfiguration()
                device?.torchMode = AVCaptureDevice.TorchMode.on //On
                //device.torchMode = AVCaptureTorchMode.On //Off
                
                
            }else{
                print("off")
                //                let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
                try device?.lockForConfiguration()
                //            device.torchMode = AVCaptureTorchMode.Off //On
                device?.torchMode = AVCaptureDevice.TorchMode.off
                //Off
            }
        }catch{
            
        }
    }
    @IBAction func keyWordSearch(){
        
        key = 1
        print("キーワード")
        performSegue(withIdentifier: "keyword", sender: nil)
        
    }
    @IBAction func newScan(_ sender: AnyObject) {
        barCodeType.text = " "
        barCodeString.text = " "
        // Start the scanner.
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        //省略
    // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            // If actual metadata type match any of the one needed
//            if UIActivity.barCodeTypes.contains((metadata as AnyObject).type) {
            if metadata is AVMetadataMachineReadableCodeObject {
                //                NSLog((metadata as! AVMetadataMachineReadableCodeObject).stringValue)
                // Stop scanner.
                self.session.stopRunning()
                // Show barcode type.
                //                barCodeType.text = metadata.type
                // Show barcode data.
                let jan = (metadata as! AVMetadataMachineReadableCodeObject).stringValue!
                
                
                let isbn = jan

                // parametersはkey名で昇順にソートされていなければならない
                // 僕はめんどくさかったので主導で雑にやってます
                let parameters = "AWSAccessKeyId=" + "AKIAIOS2GETI54FEAOTQ" + "&AssociateTag=" + "shu3302-22" + "&IdType=" + "EAN" + "&ItemId=" + isbn + "&Operation=" + "ItemLookup" + "&SearchIndex=" + "All" + "&Service=" + "AWSECommerceService" + "&Timestamp=" + Date().jpDate("yyyy-MM-dd'T'HH:mm:ssZZZZZ").urlAWSQueryEncoding()


                let target = "GET\nwebservices.amazon.co.jp\n/onca/xml\n\(parameters)"
                let signature = target.hmac(key: "lU8PvCqKaPC+8Vnu67YI4CvvrEQ3PewSY87zI4j5").urlAWSQueryEncoding()
                url = "https://webservices.amazon.co.jp/onca/xml?\(parameters)&Signature=\(signature)"
                let task = URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
                    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                }
                //        print(task.get("asin"))
                print(url)
                //        task.resume()


                loadxml()
            
                //                        barCodeType.text = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                //            print(barCodeType)
                
                
                print(barcode)
                if(barcode == ""){
                    
                }else{
                    performSegue(withIdentifier: "web", sender: nil)
                }
                
                
                break
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        //        if (segue.identifier == "keyword") {
        //            // SecondViewControllerクラスをインスタンス化してsegue（画面遷移）で値を渡せるようにバンドルする
        //            let web1 : WebView1 = segue.destinationViewController as! WebView1
        //            web1.fieldV1 = keyWordField.text!
        //            print("hello")
        ////            web1.keyV1 = key
        //            web1.segmentV1 = segment
        //            print("hello")
        //
        //        }
        if(afiriOk ==  "ok"){
            
        }else{
            if (segue.identifier == "web") {
                //            print(barcode)
                // SecondViewControllerクラスをインスタンス化してsegue（画面遷移）で値を渡せるようにバンドルする
                let web : WebView = segue.destination as! WebView
                web.barcodeV = barcode
                //            web.segmentV = segment
                
            }
        }
        
    }
    
    
    
    
}
