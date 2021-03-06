//
//  TechSupportContactViewController.swift
//  EveyDemo
//
//  Created by PROJECTS on 24/11/17.
//  Copyright © 2017 Prevaj. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation
class TechSupportContactViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var techsupportContactsTableView: UITableView!
    
    @IBOutlet weak var eveyTitle: UIImageView!
    
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var techSupportLabel: UILabel!
    
    @IBOutlet weak var techSupportProfile: UIButton!
    
    @IBOutlet weak var messageBtn: UIButton!
    
    @IBOutlet weak var callBtn: UIButton!
    
    @IBOutlet weak var emailBtn: UIButton!
    
    @IBOutlet weak var messageTxtBtn: UIButton!
    
    @IBOutlet weak var callTxtBtn: UIButton!
    
    @IBOutlet weak var emailTxtBtn: UIButton!
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var buttonsViewBorder: UILabel!
    
    
    var a = ["tech support","email"]
    var b = ["(800) 245-2445","support@ikoble.com"];
    //for beacon Detection
    var acceptableDistance = Double()
    var rssiArray = [0]
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "7878062c-1308-4ad0-9169-ec6f31c86bfa")!, identifier: "TestOne")
    
    var popup = PopupDialog(title: "", message: NSAttributedString(), buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        layOuts()
        self.techsupportContactsTableView.tableFooterView = UIView()
        // to detect beacons
        
        locationManager.delegate=self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        locationManager.startMonitoring(for: region)
        acceptableDistance = 2.0
        rssiArray.removeAll()
        let msg = "Are you finished with your visit or are you continuing care?"
        let attString = NSMutableAttributedString(string: msg)
        popup = PopupDialog(title: "", message: attString, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return techsupportContactsTableView.frame.height/3.842
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TechSupportContactsTableViewCell()
      cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TechSupportContactsTableViewCell
        cell.titleLbl.text = a[indexPath.row]
        cell.detailsLbl.text = b[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //layOuts
        
        cell.titleLbl.frame = CGRect(x: cell.contentView.frame.width/19.736, y: cell.contentView.frame.height/5.833, width: cell.contentView.frame.width/3.318, height: cell.contentView.frame.height/3.333)
        
        cell.detailsLbl.frame = CGRect(x: cell.contentView.frame.width/19.736, y: cell.titleLbl.frame.origin.y+cell.titleLbl.frame.height+cell.contentView.frame.height/17.5, width: cell.contentView.frame.width/1.209, height: cell.contentView.frame.height/3.333)
        
     return cell
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let phoneNumber = String(b[indexPath.row].characters.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
            
            let aURL = NSURL(string: "tel:\(phoneNumber)")
            if UIApplication.shared.canOpenURL(aURL! as URL) {
                UIApplication.shared.open(aURL! as URL, options: [:], completionHandler: nil)
            } else {
                print("error")
            }
        }else{
            let mailId = b[indexPath.row]
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(mailId)"])
                
                present(mail, animated: true)
            } else {
            }
  
        }
    }
    
    @IBAction func callAction(_ sender: Any) {
        
        let phoneNumber = String(b[0].characters.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
        let aURL = NSURL(string: "TEL:\(phoneNumber)")
        if UIApplication.shared.canOpenURL(aURL! as URL) {
                UIApplication.shared.open(aURL! as URL, options: [:], completionHandler: nil)
        } else {
            print("error")
        }

    }

    @IBAction func messageBtnAction(_ sender: Any) {
        if MFMessageComposeViewController.canSendText(){
        let controller  = MFMessageComposeViewController()
            controller.recipients = ["\(b[0])"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            print("failed to open")
        }

        
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mailBtnAction(_ sender: Any) {
        let mailId = "support@ikoble.com"
        
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(mailId)"])
            
            present(mail, animated: true)
        } else {
        }

    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        let contacts = self.storyboard?.instantiateViewController(withIdentifier: "ContactsDummyViewController") as! ContactsDummyViewController
        let transition = CATransition()
        transition.duration = 0
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        locationManager.stopMonitoring(for: region)
        locationManager.stopRangingBeacons(in: region)

        self.present(contacts, animated: false, completion: nil)

    }
    @IBAction func menuBtnAction(_ sender: Any) {
        let menuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let transition = CATransition()
        transition.duration = 0
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        locationManager.stopMonitoring(for: region)
        locationManager.stopRangingBeacons(in: region)

        self.present(menuViewController, animated: false, completion: nil)
    }
    
    func layOuts(){
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        
        eveyTitle.frame = CGRect(x: screenWidth/2.757, y: screenHeight/23.821, width: screenWidth/3.75, height: screenHeight/27.791)
        
        menuBtn.frame = CGRect(x: eveyTitle.frame.origin.x+eveyTitle.frame.size.width+screenWidth/4.166, y: screenHeight/23.821, width: screenWidth/11.363, height: screenHeight/31.761)
        
        techSupportLabel.frame = CGRect(x: screenWidth/46.875, y: eveyTitle.frame.origin.y+eveyTitle.frame.height+screenHeight/31.761, width: screenWidth/1.518, height: screenHeight/19.057)
        
        techSupportProfile.frame = CGRect(x: screenWidth/2.622, y: techSupportLabel.frame.origin.y+techSupportLabel.frame.height+screenHeight/25.653, width: screenWidth/4.166, height: screenHeight/7.411)
        
        messageBtn.frame = CGRect(x: screenWidth/5.859, y: techSupportProfile.frame.origin.y+techSupportProfile.frame.height+screenHeight/23.821, width: screenWidth/8.333, height: screenHeight/14.822)
        
        callBtn.frame = CGRect(x: messageBtn.frame.origin.x+messageBtn.frame.width+screenWidth/6.818, y: techSupportProfile.frame.origin.y+techSupportProfile.frame.height+screenHeight/23.821, width: screenWidth/8.333, height: screenHeight/14.822)

        emailBtn.frame = CGRect(x: callBtn.frame.origin.x+callBtn.frame.width+screenWidth/6.818, y: techSupportProfile.frame.origin.y+techSupportProfile.frame.height+screenHeight/23.821, width: screenWidth/8.333, height: screenHeight/14.822)
        
        messageTxtBtn.frame = CGRect(x: screenWidth/6.696, y: messageBtn.frame.origin.y+messageBtn.frame.height, width: screenWidth/6.048, height: screenHeight/22.233)
        
        callTxtBtn.frame = CGRect(x: messageTxtBtn.frame.origin.x+messageTxtBtn.frame.width+screenWidth/6.9444, y: messageBtn.frame.origin.y+messageBtn.frame.height, width: screenWidth/12.5, height: screenHeight/22.233)
        
        emailTxtBtn.frame = CGRect(x: callTxtBtn.frame.origin.x+callTxtBtn.frame.width+screenWidth/5.681, y: messageBtn.frame.origin.y+messageBtn.frame.height, width: screenWidth/10.135, height: screenHeight/22.233)
        
        techsupportContactsTableView.frame = CGRect(x: 0, y: messageTxtBtn.frame.origin.y+messageTxtBtn.frame.height+screenHeight/37.055, width: screenWidth, height: screenHeight/2.479)
        
        buttonsView.frame = CGRect(x: 0, y: techsupportContactsTableView.frame.origin.y+techsupportContactsTableView.frame.height, width: screenWidth, height: screenHeight/12.584)
        
        buttonsViewBorder.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 1)
        
        cancelBtn.frame = CGRect(x: screenWidth/1.315, y: buttonsView.frame.height/4.818, width: screenWidth/5.281, height: buttonsView.frame.height/1.766)
        
        //corner Radius
        
        techSupportProfile.layer.cornerRadius = techSupportProfile.frame.height/2
        
        messageBtn.layer.cornerRadius = messageBtn.frame.height/2

        callBtn.layer.cornerRadius = callBtn.frame.height/2
        
        emailBtn.layer.cornerRadius = emailBtn.frame.height/2
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{$0.proximity != CLProximity.unknown}
        if (knownBeacons.count>0) {
            let closeBeacon = knownBeacons[0] as CLBeacon
            var maj =  Int()
            maj =  8
            let previousBeaconArray : [Int] = UserDefaults.standard.value(forKey: "PreviousBeaconArray") as! [Int]
            if previousBeaconArray.count == 0 {
                if closeBeacon.major.intValue == maj {
                }else{
                    rssiArray.append(closeBeacon.rssi)
                    if rssiArray.count == 1 {
                        let sumedrssi = rssiArray.reduce(0, +)
                        let processedrssi = sumedrssi/1
                        let base = Double(10)
                        let power = Double(-57-(processedrssi))/Double(10*2)
                        let dis = pow(Double(base), power)
                        print("\(closeBeacon.major.intValue)")
                        print("\(closeBeacon.rssi)")
                        print("accuracy \(closeBeacon.accuracy)")
                        print(dis)
                        rssiArray.removeAll()
                        //if closeBeacon.accuracy <= 4.0 {
                        if dis <= 4.0{
                            UserDefaults.standard.set([closeBeacon.major.intValue], forKey: "PreviousBeaconArray")
                            
                            popup.dismiss(animated: true, completion: {
                                UserDefaults.standard.set([], forKey: "HallwayBeaconArray")
                                
                            })
                            locationManager.stopRangingBeacons(in: region)
                            locationManager.stopMonitoring(for: region)
                            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "ResidentSelectTestViewController") as! ResidentSelectTestViewController
                            self .present(nvc, animated: true, completion: {
                                UserDefaults.standard.set([], forKey: "SelectedArray")
                                UserDefaults.standard.set("", forKey: "Came From")
                            })
                        }
                    }
                }
                
            }else{
                if closeBeacon.major.intValue == maj {
                    rssiArray.append(closeBeacon.rssi)
                    if rssiArray.count == 1 {
                        let sumedrssi = rssiArray.reduce(0, +)
                        let processedrssi = sumedrssi/1
                        let base = Double(10)
                        let power = Double(-59-(processedrssi))/Double(10*2)
                        let dis = pow(Double(base), power)
                        print("\(closeBeacon.major.intValue)")
                        print("\(closeBeacon.rssi)")
                        print("accuracy \(closeBeacon.accuracy)")
                        print(dis)
                        rssiArray.removeAll()
                        //if closeBeacon.accuracy <= 3.0 {
                        if dis <= 3{
                            print("After")
                            UserDefaults.standard.set("Center", forKey: "PlaceOfAlert")
                            let msg = "Are you finished with your visit or are you continuing care?"
                            let attString = NSMutableAttributedString(string: msg)
                            
                            popup = PopupDialog(title: "", message: attString,  buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: {
                                
                            })

                            let pauseButton = CancelButton(title: "Pause", action: {
                                
                                UserDefaults.standard.set("Top", forKey: "PlaceOfAlert")

                                let namesArray : [String] = UserDefaults.standard.value(forKey: "NamesArray") as! [String]
                                
                                let selectedArray : [String] = UserDefaults.standard.value(forKey: "SelectedArray") as! [String]
                                if namesArray.count == 0 && selectedArray.count == 0 {
                                        let RSVC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentSelectTestViewController") as! ResidentSelectTestViewController
                                        self.locationManager.stopMonitoring(for: region)
                                        self.locationManager.stopRangingBeacons(in: region)
                                        RSVC.alertForPause = true
                                        self.present(RSVC, animated: true, completion: {
                                            UserDefaults.standard.set([], forKey: "NamesArray")
                                            UserDefaults.standard.set([], forKey: "SelectedArray")
                                            UserDefaults.standard.set([], forKey: "PreviousBeaconArray")
                                            UserDefaults.standard.set([], forKey: "HallwayBeaconArray")
                                            
                                        })

                                    }else{
                                    let nvc = self.storyboard?.instantiateViewController(withIdentifier: "CareSelectViewController") as! CareSelectViewController
                                    self.locationManager.stopRangingBeacons(in: region)
                                    self.locationManager.stopMonitoring(for: region)
                                    nvc.alertForPause = true
                                    self.present(nvc, animated: true, completion: {
                                        UserDefaults.standard.set([], forKey: "HallwayBeaconArray")
                                        
                                    })
                                    
                                }
                                
                            })
                            
                            let continueButton = CancelButton(title: "Continue", action: {
                                
                                UserDefaults.standard.set("Top", forKey: "PlaceOfAlert")

                                let namesArray : [String] = UserDefaults.standard.value(forKey: "NamesArray") as! [String]
                                
                                let selectedArray : [String] = UserDefaults.standard.value(forKey: "SelectedArray") as! [String]
                                if namesArray.count == 0 && selectedArray.count == 0 {
                                    let RSVC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentSelectTestViewController") as! ResidentSelectTestViewController
                                    self.locationManager.stopMonitoring(for: region)
                                    self.locationManager.stopRangingBeacons(in: region)
                                    RSVC.alertForContinue = true
                                    self.present(RSVC, animated: true, completion: {
                                        UserDefaults.standard.set([], forKey: "NamesArray")
                                        UserDefaults.standard.set([], forKey: "SelectedArray")
                                        UserDefaults.standard.set([], forKey: "PreviousBeaconArray")
                                        UserDefaults.standard.set([], forKey: "HallwayBeaconArray")
                                        
                                    })
                                    
                                }else{
                                    let nvc = self.storyboard?.instantiateViewController(withIdentifier: "CareSelectViewController") as! CareSelectViewController
                                    self.locationManager.stopRangingBeacons(in: region)
                                    self.locationManager.stopMonitoring(for: region)
                                    nvc.alertForContinue = true
                                    self.present(nvc, animated: true, completion: {
                                        UserDefaults.standard.set([], forKey: "HallwayBeaconArray")
                                        
                                    })
                                    
                                }
                                

                            })
                            
                            let completeButton = CancelButton(title: "Complete", action: {
                                
                                UserDefaults.standard.set("Top", forKey: "PlaceOfAlert")

                                let namesArray : [String] = UserDefaults.standard.value(forKey: "NamesArray") as! [String]
                                
                                let selectedArray : [String] = UserDefaults.standard.value(forKey: "SelectedArray") as! [String]
                                if namesArray.count == 0 && selectedArray.count == 0 {
                                    let RSVC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentSelectTestViewController") as! ResidentSelectTestViewController
                                    self.locationManager.stopMonitoring(for: region)
                                    self.locationManager.stopRangingBeacons(in: region)
                                    RSVC.alertForComplete = true
                                    self.present(RSVC, animated: true, completion: {
                                        UserDefaults.standard.set([], forKey: "NamesArray")
                                        UserDefaults.standard.set([], forKey: "SelectedArray")
                                        UserDefaults.standard.set([], forKey: "PreviousBeaconArray")
                                        UserDefaults.standard.set([], forKey: "HallwayBeaconArray")
                                        
                                    })
                                    
                                }else{
                                    let nvc = self.storyboard?.instantiateViewController(withIdentifier: "CareSelectViewController") as! CareSelectViewController
                                    self.locationManager.stopRangingBeacons(in: region)
                                    self.locationManager.stopMonitoring(for: region)
                                    nvc.alertForComplete = true
                                    self.present(nvc, animated: true, completion: {
                                        UserDefaults.standard.set([], forKey: "HallwayBeaconArray")
                                        
                                    })
                                    
                                }

                            })
                            
                            let deleteButton = DestructiveButton(title: "Delete", action: {
                                
                                UserDefaults.standard.set("Top", forKey: "PlaceOfAlert")

                            })
                            popup.addButtons([pauseButton,continueButton,completeButton,deleteButton])
                            
                            let hallwayBeaconArray : [Int] = UserDefaults.standard.value(forKey: "HallwayBeaconArray") as! [Int]
                            if hallwayBeaconArray.count == 0 {
                                let namesArray : [String] = UserDefaults.standard.value(forKey: "NamesArray") as! [String]
                                let selectedArray : [String] = UserDefaults.standard.value(forKey: "SelectedArray") as! [String]
                                if namesArray.count >= 1 && selectedArray.count == 0{
                                    let DVC = storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
                                    UserDefaults.standard.set([], forKey: "HallwayBeaconArray")
                                    UserDefaults.standard.set([], forKey: "PreviousBeaconArray")
                                    UserDefaults.standard.set([], forKey: "NamesArray")
                                    UserDefaults.standard.set([], forKey: "SelectedArray")
                                    locationManager.stopRangingBeacons(in: region)
                                    locationManager.stopMonitoring(for: region)
                                    
                                    self.present(DVC, animated: true, completion: nil)
                                }else{
                                    

                                    self.present(popup, animated: true, completion: {
                                        UserDefaults.standard.set("Top", forKey: "PlaceOfAlert")

                                        UserDefaults.standard.set([closeBeacon.major.intValue], forKey: "HallwayBeaconArray")
                                        UserDefaults.standard.set([], forKey: "PreviousBeaconArray")
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
