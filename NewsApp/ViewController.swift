//
//  ViewController.swift
//  NewsApp
//
//  Created by Junyoung Lee on 2021/08/29.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    var newsData : Array<Dictionary<String, Any>>?
    
    // 1. http 통신 방법
    // 2. json 데이터 형태 {"":""}
    // 3. 테이블뷰의 데이터 매칭 <- 통보
    // !!! background : network / ui : Main
    
    // newsapi.org
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string:"https://newsapi.org/v2/top-headlines?country=kr&apiKey=5d4e1095dd6f48f4864d5f778a72162d")!) { (data, response, error) in
            if let dataJson = data{
                //json 으로 parsing 한다
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    print(json)
                    //Dictionary
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    print(articles)
                    self.newsData = articles
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData() //Main
                    }
                }
                catch{}
            }
        }
        task.resume()
    }
    
    // 셀을 반복할 횟수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let news = newsData{
            return news.count
        } else{
            return 0
        }
    }
    
    // 위의 numberOfRowsInSection 숫자 만큼 반복
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // as? as! 부모 자식 친자확인
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        let idx = indexPath.row
        if let news = newsData{
            let row = news[idx]
            if let r = row as? Dictionary<String, Any>{
                if let title = r["title"] as? String{
                    cell.LabelText.text = title
                }
            }
        }
        
        return cell
    }
    
    // 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        
        getNews()
    }


}

