//
//  Intro.swift
//  Jeopardy
//
//  Created by Becca Gottlieb on 11/8/20.
//  Copyright © 2020 Becca Gottlieb. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class IntroScene: SKScene
{
    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "jeopardyBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(2)
        background.zPosition = -1
        addChild(background)
        
        let intro = SKAction.playSoundFileNamed("intro",waitForCompletion:false)
        
        let titleLabel = SKSpriteNode(imageNamed: "jeopardy")
        titleLabel.position = CGPoint(x:333.5, y:340)
        titleLabel.setScale(2)
        addChild(titleLabel)
        titleLabel.run(intro)
        
        let grow = SKAction.resize(byWidth: 2, height: 2, duration: 2)
        titleLabel.run(grow)
        
//        let scene = GameScene(fileNamed: "GameScene")!
//        let transition = SKTransition.moveIn(with: .right, duration: 1)
//        self.view?.presentScene(scene, transition: transition)
    }
}
