//
//  GameScene.swift
//  Jeopardy
//
//  Created by Becca Gottlieb on 10/28/20.
//  Copyright © 2020 Becca Gottlieb. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    
    static var usedButtons : [Bool] = []
    static var gameSceneLaunched = 0
    
    static var isSoundOn = true
    static let soundOnButton = SKSpriteNode(imageNamed: "soundOn")
    static let soundOffButton = SKSpriteNode(imageNamed: "soundOff")
    
    var labels : [SKLabelNode] = []
    var buttons : [SKSpriteNode] = []
    var buttonLabels : [SKLabelNode] = []
    var testing = false
    
    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "jeopardyBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(2)
        background.zPosition = -1
        addChild(background)
        
        let titleLabel = SKSpriteNode(imageNamed: "jeopardy")
        titleLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - (self.size.height/9))
        titleLabel.setScale(0.5)
        addChild(titleLabel)
        
        GameScene.soundOnButton.position = CGPoint(x: self.size.width/9, y: self.size.height - (self.size.height/9))
        GameScene.soundOnButton.setScale(0.25)
        GameScene.soundOnButton.name = "sound"
        if GameScene.isSoundOn {addChild(GameScene.soundOnButton)}
        else {addChild(GameScene.soundOffButton)}
        
        let intro = SKAction.playSoundFileNamed("intro",waitForCompletion:false)
        if GameScene.gameSceneLaunched == 0 && GameScene.isSoundOn == true {titleLabel.run(intro)}
        
        let scoreLabel = SKLabelNode(fontNamed: "Copperplate")
        scoreLabel.text = ("$\(ResultScene.totalPoints)")
        scoreLabel.position = CGPoint(x:self.size.width - (self.size.width/9), y:self.size.height - (self.size.height/9))
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.orange
        addChild(scoreLabel)
        
        let labelList = ["English", "Geography", "History", "Latin", "Math"]
        
        var xOffset : Int = 0
        
        for i in 0...4
        {
            labels.append(SKLabelNode())
            labels[i] = SKLabelNode(fontNamed: "Copperplate")
            labels[i].text = labelList[i]
            labels[i].fontSize = 20
            labels[i].fontColor = SKColor.white
            if self.size.width > 667.0 {xOffset = Int((self.size.width - 667)/2)}
            labels[i].position = CGPoint(x:(Int(self.size.width)/12 + xOffset) + i * 140, y: 290)
            addChild(labels[i])
        }
        
        var y = 260
        var ctr = 0
        var value = 100
        
        for i in 0...24
        {
            buttons.append(SKSpriteNode())
            if GameScene.gameSceneLaunched == 0 {GameScene.usedButtons.append(false)}
            if GameScene.usedButtons[i] == false {buttons[i].color = SKColor.blue}
            else {buttons[i].color = SKColor.gray}
            buttons[i].size = CGSize(width: 80, height: 50)
            buttons[i].position = CGPoint(x:(Int(self.size.width)/12 + xOffset) + ctr * 140, y: y)
            buttons[i].zPosition = 0
            
            buttonLabels.append(SKLabelNode())
            buttonLabels[i] = SKLabelNode(fontNamed: "Copperplate")
            buttonLabels[i].text = "$\(value)";
            buttonLabels[i].fontSize = 25
            buttonLabels[i].position = CGPoint(x: buttons[i].frame.midX, y: buttons[i].frame.midY-10)
            buttonLabels[i].fontColor = SKColor.yellow
            buttonLabels[i].zPosition = 1
            
            self.addChild(buttons[i])
            self.addChild(buttonLabels[i])
            
            if ctr % 4 == 0 && ctr != 0
            {
                y -= 55
                value += 100
            }
            ctr += 1
            if ctr == 5 {ctr = 0}
        }
        isGameOver()
    }
    
    func activated(_ index: Int)
    {
        if testing == false
        {
            let questionScene = QuestionScene(size: self.size, buttonIndex: index)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(questionScene, transition: reveal)
        }
        else
        {
            let questionScene = BonusRound(size: self.size)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(questionScene, transition: reveal)
        }
    }
    
    func soundToggleButton()
    {
        GameScene.isSoundOn.toggle()
        if GameScene.isSoundOn
        {
            GameScene.soundOffButton.removeFromParent()
            addChild(GameScene.soundOnButton)
        }
        else
        {
            GameScene.soundOffButton.position = CGPoint(x:self.size.width/9, y:self.size.height - (self.size.height/9))
            GameScene.soundOffButton.setScale(0.25)
            GameScene.soundOffButton.name = "sound"
            addChild(GameScene.soundOffButton)
            GameScene.soundOnButton.removeFromParent()
        }
    }
    
    func isGameOver()
    {
        if GameScene.gameSceneLaunched == 25
        {
            if ResultScene.totalPoints >= 5000
            {
                let bonusRound = BonusRound(size: self.size)
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                self.view?.presentScene(bonusRound, transition: reveal)
            }
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: 3.0),
                SKAction.run() { [weak self] in
                    
                    guard let `self` = self else { return }
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene = GameOver(size: self.size)
                    self.view?.presentScene(scene, transition:reveal)
                }
            ]))
        }
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
                {
                    if GameScene.usedButtons[index] == false
                    {
                        activated(index)
                        GameScene.usedButtons[index] = true
                    }
                }
            }
            let location = touch.location(in: self)
            let soundButton = atPoint(location)
            if soundButton.name == "sound" {soundToggleButton()}
        }
    }
}
