//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Angus Lee on 2020/2/11.
//  Copyright © 2020 Angus Lee. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    //设置主题字典
    let themes = [
        "Sports": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐️", "🎱", "🏓️", "⛳️", "🎳", "🏸️"],
        "Animals": ["🐶", "🐔", "🦊", "🐼", "🦀️", "🐫", "🐙", "🐳", "🐒", "🐎", "🐘"],
        "Faces": ["😊", "😂", "😭", "😅", "🙄️", "🥱", "😷", "🤔", "😪", "😎", "😏"]
    ]
    
    //以下两个func是为了解决第一次进入没有theme时，进入的是splitview的master
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController{
            if cvc.theme == nil{
                return true
            }
        }
        return false
    }
    
    //判断splitview有没有得到使用（iPad还是iPhone）
    private var splitViewDetailConcentrationViewController: ConcentrationViewController?{
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    //几个按钮的action
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController{        //splitview使用了Detial，只改变theme（iPad）
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController{    //如果已经进入了Concentration中，则也只改变theme（iPhone）
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
                navigationController?.pushViewController(cvc, animated: true)
            } else{
            performSegue(withIdentifier: "Choose Theme", sender: sender)        //否则重建MVC（目前版本不可用）
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //在已经选择过theme之后，保存这个状态
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //跳转为Choose Theme时，根据对应按钮的名字选择主题
        if segue.identifier == "Choose Theme" {
            //sender为按钮，且按钮名为主体名时修改主题
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let cvc = segue.destination as? ConcentrationViewController{
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
