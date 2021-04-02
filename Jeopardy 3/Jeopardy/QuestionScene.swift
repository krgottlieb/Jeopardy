//
//  QuestionScene.swift
//  Jeopardy
//
//  Created by Becca Gottlieb on 11/1/20.
//  Copyright © 2020 Becca Gottlieb. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVKit

class QuestionScene: SKScene
{
    
    var buttons : [SKSpriteNode] = []
    var buttonLabels : [SKLabelNode] = []
    var questionToDisplay : Int? = nil
    var cashValue : Int = 100
    var questionArray : [String] = []
    var answerArray : [String] = []
    
    static var engAArray : [String] = []
    static var geoAArray : [String] = []
    static var hisAArray : [String] = []
    static var latinAArray : [String] = []
    static var mathAArray : [String] = []
    
    static var engQArray : [String] = []
    static var geoQArray : [String] = []
    static var hisQArray : [String] = []
    static var latinQArray : [String] = []
    static var mathQArray : [String] = []
    
    static var engQArrayUsed : [Int] = []
    static var geoQArrayUsed : [Int] = []
    static var hisQArrayUsed : [Int] = []
    static var latinQArrayUsed : [Int] = []
    static var mathQArrayUsed : [Int] = []
    
    init(size: CGSize, buttonIndex: Int)
    {
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "jeopardyBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(2)
        background.zPosition = -1
        addChild(background)
        
        let backgroundMusic = SKAudioNode(fileNamed: "thinkMusic")
        backgroundMusic.autoplayLooped = true
        if GameScene.isSoundOn == true {addChild(backgroundMusic)}
        
        if QuestionScene.engAArray.count == 0
        {
            QuestionScene.engAArray = Array(englishDictionary.keys)
            QuestionScene.geoAArray = Array(geographyDictionary.keys)
            QuestionScene.hisAArray = Array(historyDictionary.keys)
            QuestionScene.latinAArray = Array(latinDictionary.keys)
            QuestionScene.mathAArray = Array(mathDictionary.keys)
            
            QuestionScene.engQArray = Array(englishDictionary.values)
            QuestionScene.geoQArray = Array(geographyDictionary.values)
            QuestionScene.hisQArray = Array(historyDictionary.values)
            QuestionScene.latinQArray = Array(latinDictionary.values)
            QuestionScene.mathQArray = Array(mathDictionary.values)
        }
        
        func setLabelsAndQuestion(_ count: Int, _ answer: [String], _ question: [String], _ usedArray: [Int])
        {
            var number: Int
            var candidates: [Int] = []
            
            for i in 0 ... (count-1)
            {
                if !usedArray.contains(i) {candidates.append(i)}
                candidates.shuffle()
            }
            
            for _ in 0 ... 3
            {
                number = candidates.removeFirst()
                questionArray.append(question[number])
                answerArray.append(answer[number])
            }
        }
        
        func whichQuestion(_ buttonIndex: Int)
        {
            var count = 0
            switch buttonIndex
            {
            case 0, 5, 10, 15, 20:
                count = englishDictionary.count
                setLabelsAndQuestion(count, QuestionScene.engAArray, QuestionScene.engQArray, QuestionScene.engQArrayUsed)
            case 1, 6, 11, 16, 21:
                count = geographyDictionary.count
                setLabelsAndQuestion(count, QuestionScene.geoAArray, QuestionScene.geoQArray, QuestionScene.geoQArrayUsed)
            case 2, 7, 12, 17, 22:
                count = historyDictionary.count
                setLabelsAndQuestion(count, QuestionScene.hisAArray, QuestionScene.hisQArray, QuestionScene.hisQArrayUsed)
            case 3, 8, 13, 18, 23:
                count = latinDictionary.count
                setLabelsAndQuestion(count, QuestionScene.latinAArray, QuestionScene.latinQArray, QuestionScene.latinQArrayUsed)
            case 4, 9, 14, 19, 24:
                count = mathDictionary.count
                setLabelsAndQuestion(count, QuestionScene.mathAArray, QuestionScene.mathQArray, QuestionScene.mathQArrayUsed)
            default:
                print("something went wrong")
            }
        }
        
        whichQuestion(buttonIndex)
        
        func questionValue(_ buttonIndex: Int) -> Int
        {
            return buttonIndex / 5 * 100 + 100
        }
        
        cashValue = questionValue(buttonIndex)
        
        func discardUsedQuestions(_ questionToDisplay: Int)
        {
            let chosenQuestion = questionArray[questionToDisplay]
            
            switch chosenQuestion
            {
            case _ where QuestionScene.engQArray.contains(chosenQuestion):
                QuestionScene.engQArrayUsed.append((QuestionScene.engQArray.firstIndex (of: chosenQuestion)!))
            case _ where QuestionScene.geoQArray.contains(chosenQuestion):
                QuestionScene.geoQArrayUsed.append((QuestionScene.geoQArray.firstIndex (of: chosenQuestion)!))
            case _ where QuestionScene.hisQArray.contains(chosenQuestion):
                QuestionScene.hisQArrayUsed.append((QuestionScene.hisQArray.firstIndex (of: chosenQuestion)!))
            case _ where QuestionScene.latinQArray.contains(chosenQuestion):
                QuestionScene.latinQArrayUsed.append((QuestionScene.latinQArray.firstIndex (of: chosenQuestion)!))
            case _ where QuestionScene.mathQArray.contains(chosenQuestion):
                QuestionScene.mathQArrayUsed.append((QuestionScene.mathQArray.firstIndex (of: chosenQuestion)!))
            default:
                print("something went wrong")
            }
        }
        
        let question = SKLabelNode(fontNamed: "Copperplate")
        questionToDisplay = questionArray.indices.randomElement()
        discardUsedQuestions(questionToDisplay!)
        question.text = questionArray[questionToDisplay!]
        question.preferredMaxLayoutWidth = 600
        question.numberOfLines = 0
        question.position = CGPoint(x: self.size.width/2, y: 250)
        question.fontColor = SKColor.white
        question.fontSize = 40
        addChild(question)
        
        var ctr = 0
        
        for i in 0...3
        {
            var y = 175
            if i > 1 {y = 75}
            if ctr == 2 {ctr = 0}
            
            buttons.append(SKSpriteNode())
            buttons[i].color = SKColor.blue
            buttons[i].position = CGPoint(x:Int(self.size.width/3) + ctr * 250, y: y)
            buttons[i].zPosition = 0
            
            buttonLabels.append(SKLabelNode())
            buttonLabels[i] = SKLabelNode(fontNamed: "Copperplate")
            buttonLabels[i].text = answerArray[i]
            buttonLabels[i].numberOfLines = 0
            buttonLabels[i].preferredMaxLayoutWidth = 130
            buttonLabels[i].fontSize = 20
            buttonLabels[i].fontColor = SKColor.white
            buttonLabels[i].zPosition = 1
            
            var multiLineShift = buttons[i].frame.midY-10
            let width = (Int(buttonLabels[i].frame.maxX - buttonLabels[i].frame.minX))
            let height = (Int(buttonLabels[i].frame.maxY - buttonLabels[i].frame.minY))
            if height == 42 {multiLineShift = multiLineShift - 11}
            else if height > 42 {multiLineShift = multiLineShift - 22}
            
            buttonLabels[i].position = CGPoint(x: buttons[i].frame.midX, y: multiLineShift)
            buttons[i].size = CGSize(width: width + 25, height: height + 25)
            
            self.addChild(buttons[i])
            self.addChild(buttonLabels[i])
            ctr += 1
        }
    }
    
    func checkIt(_ buttonIndex: Int) -> Int
    {
        //default set to 2 or wrong, only switches to 1 if answer is correct
        var answer = 2
        if buttonIndex == questionToDisplay {answer = 1}
        return answer
    }
    
    func activated(_ index: Int)
    {
        let result = checkIt(index)
        let questionScene = ResultScene(size: self.size, buttonIndex: index, result: result, cashValue: cashValue)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        self.view?.presentScene(questionScene, transition: reveal)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches
        {
            for button in buttons
            {
                let index = buttons.firstIndex(of: button)!
                let location = touch.location(in: self)
                if button.contains(location)
                {activated(index)}
            }
        }
    }
    
    var englishDictionary: [String:String] = ["verb": "a word that shows action or state of being", "article": "an adjective that tells if a noun is a general or specific", "adverb": "describes a verb or an adjective", "conjunction": "a word that joins two words to two phrases together", "noun": "a person a place, a thing, or an idea", "adjective": "a word that describes a noun", "preposition": "words that show location in time and/or space", "interjection": "a word that expresses an emotion or feeling", "present participle":"a verb plus -ing", "past participle":"verb plus -ed", "principal parts of verbs":"infinitive, present, past, and present and past participles", "infinitive":"to plus a verb, used as a noun"]
    
    var geographyDictionary : [String:String] = ["Hartford":"The capital of Connecticut", "Providence":"The capital of Rhode Island", "Boston":"The capital of Massachusetts", "Concord":"The capital of New Hampshire", "Augusta":"The capital of Maine", "Dover":"The capital of Deleware", "Harrisburg":"The capital of Pennsylvania", "Trenton":"The capital of New Jersey", "Albany":"The capital of New York", "Montpelier":"The capital of Vermont", "Washington, DC":" The capital of USA", "Columbia":"The capital of South Carolina", "Raleigh":"The capital of North Carolina", "Charleston":"The capital of West Virginia", "Richmond":"The capital of Virginia", "Annapolis":"The capital of Maryland", "Lansing":"The capital of Michigan", "Columbus":"The capital of Ohio", "Indianapolis":"The capital of Indiana", "Nashville":"The capital of Tennessee", "Madison": "The capital of Wisconsin", "Springfield": "The capital of Illinois", "Frankfort": "The capital of Kentucky", "Atlanta": "The capital of Georgia", "Tallahassee": "The capital of Florida", "Montgomery": "The capital of Alabama", "Jackson": "The capital of Mississippi", "Baton Rouge": "The capital of Lousiana", "St.Paul": "The capital of Minnesota", "Des Moines": "The capital of Iowa", "Jefferson City": "The capital of Missouri", "Little Rock": "The capital of Arkansas", "Bismarck": "The capital of North Dakota", "Pierre": "The capital of South Dakota", "Lincoln": "The capital of Nebraska", "Topeak": "The capital of Kansas", "Oklahoma City": "The capital of Oklahoma", "Austin": "The capital of Texas", "Chyenne": "The capital of Wyoming", "Denver": "The capital of Colorado", "Santa Fe": "The capital of New Mexico", "Salt Lake City": "The capital of Utah", "Phoenix": "The capital of Arizona", "Carson City": "The capital of Nevada", "Sacramento": "The capital of California", "Honolulu": "The capital of Hawaii"]
    
    var historyDictionary : [String:String] = ["Columbus":"In 1492, this man made the first of four trips to the Caribbean on three Spanish ships.", "Pilgrims":"In 1620, these individuals sailed from Plymouth, England and signed the Mayflower Compant.", "Boston Tea Party":"In 1773, colonists disguised as Mohawks dumped tea into the Boston Harbor", "Declaration of Indepndence":"In 1776, the Continental Congress published this document.", "George Washington":"In 1789, in New York, this man was granted the full powers for the presidency.", "Louisiana Purchase": "In 1803, a purchase from France prompted westward exploration.", "Monroe Doctrine": "After victory in the war of 1812, the United States wrote this document.", "Missouri Compromise": "In 1820, Henry Clay worked out this agreement.", "Secession Southern States": "The Compromise of 1850, the Fugitive Slave Act and the Dred Scott decision.", "Manifest Destiny":"President Polk believed that the Mexican War and the Gadsden Purchase affirmed this."]
    
    var latinDictionary : [String:String] = ["in":"in", "with":"apud", "by":"per", "without":"sine", "from":"a", "of":"de", "and":"et", "that":"ut", "not":"non", "was":"erat", "came":"venit", "bear": "perhiberet", "believe":"crederent", "were made":"facta sunt", "was made":"factum est", "sent":"missus", "comprehend":"conprehenderunt", "shineth": "lucet", "there was": "fuit", "word":"verbum", "God": "Deus, Deum, Deo", "all":"omnia, omnes", "nothing":"nihil", "life":"vita", "light":"lux or lumine", "man":"homo or hominum", "name":"nomen", "witness or testimony": "testimonium", "John":"Lohannes", "darkness":"tenebris or tenebrae", "Latin words have different endings": "conjugations", "Latin has no translation for these articles":"a, an, and the"]
    
    var mathDictionary : [String:String] = ["0":"8x0", "8":"8x1", "16":"8x2", "24":"8x3", "32":"8x4", "40":"8x5", "48":"8x6", "56":"8x7", "64":"8x8", "72":"8x9", "80":"8x10", "88":"8x11", "96":"8x12", "104":"8x13", "112":"8x14", "120":"8x15"]
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
