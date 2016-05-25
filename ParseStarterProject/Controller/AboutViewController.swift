//
//  AboutViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 17/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    let SegueLoginViewController = "LoginViewController"

    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var authorImageView: UIImageView!
    
    @IBAction func icon8Clicked(sender: AnyObject) {
        if let url = NSURL(string: "https://icons8.com/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    //--------------------------------------
    // MARK: - Life Cycle Methods
    //--------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("About")
        
        self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2
        self.authorImageView.clipsToBounds = true
        
        self.aboutLabel.text = "שהיו של קיקרו, Lorem Ipsum תמתוך Lorem Ipsum ודרךציטוטים של המילה מתוך הספרות הקלאסית, הוא גילה מקור בלתי ניתן לערעור ציטוטים של המילה מתוך הספרות הקלאסית, הוא גילה מקור בלתי ניתן לערעור ציטוטים של המילה מתוך הספרות הקלאסית, הוא גילה מקור בלתי ניתן לערעור. Lorem Ipsum מגיע מתוך מקטע 1.10.32 ו- 1.10.33 של \"de Finibus Bonorum et Malorum\" (הקיצוניות של הטוב והרע) שנכתב על ידי קיקרו ב-45 לפני הספירה. ספר זה הוא מאמר על תאוריית האתיקה, שהיה מאוד מפורסם בתקופת הרנסנס. השורה הראשונה של \"Lorem ipsum dolor sit amet\", שמופיעה בטקסטים של Lorem Ipsum, באה משורה במקטע 1.10.32"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AboutViewController.doubleTapped))
        tap.numberOfTapsRequired = 2
        self.authorImageView.userInteractionEnabled = true
        self.authorImageView.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func doubleTapped() {

        if ParseHelper.currentUser() != nil {
            self.showAlert()
        } else {
            self.performSegueWithIdentifier(SegueLoginViewController, sender: nil)
        }

    }

    //--------------------------------------
    // MARK: - Helper methods
    //--------------------------------------
    
    func showAlert() {
        SCLAlertViewHelper.sharedInstance.showInfoAlert("alreadyLoggedIn")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
