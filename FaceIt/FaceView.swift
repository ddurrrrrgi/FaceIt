//
//  FaceView.swift
//  FaceIt
//
//  Created by RGP_KOREA on 2016. 11. 13..
//  Copyright © 2016년 DDRG. All rights reserved.
//

import UIKit

class FaceView: UIView
{
    var scale: CGFloat = 0.90
    
    var mouthCurvature: Double = 1.0 // 1 full smile, -1 full frown
    
    private var skullRadius: CGFloat { //계산 프로퍼티(값을 가져오기만 하기때문에 get필요없음)
        return min(bounds.size.width, bounds.size.height) / 2 * scale //반경
    }
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY) //센터
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusTOMouthOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = 5.0
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset //eyeOffset만큼 위로 올라감
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter

    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeith = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusTOMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeith)
        
        //return UIBezierPath(rect: mouthRect)

        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
    }
    
    override func drawRect(rect: CGRect)
    {
        //스위프트는 리터럴(직접 값을 나타내는 형태)에 대해 자동으로 타입변환을 할 수 있음
        UIColor.blueColor().set() //fill과 stroke를 모두 설정하는 set
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke() //체이닝방식(skull변수를 만들지 않고도 skullCenter와 skullRadius를 가져옴)
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
    }
}
























