import UIKit

@IBDesignable class GraphView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    // ダミーデータ
//    var graphPoints:[Int] = []
    var graphPoints:[Int] = [4, 2, 6, 4, 5, 8, 3]
    
    var graphDays:[String] = ["8/12", "8/11", "8/10", "8/9", "8/8", "8/7", "8/6"]
    
    var graphDatas = [100, 30, 10, -50, 90, 12, 40]
    
    // グラフのプロットデータ設定用のメソッドです。
    func setupPoints(points: [Int]) {
        graphPoints = points
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        
        // グラデーション
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.AllCorners,
        
                                cornerRadii: CGSize(width: 8.0, height: 8.0))
        //角丸
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace,
                                                  colors,
                                                  colorLocations)
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
                                    gradient,
                                    startPoint,
                                    endPoint,
                                    .DrawsBeforeStartLocation)
        
        
        // X座標の計算
        let margin:CGFloat = 20.0
        let columnXPoint = { (column:Int) -> CGFloat in
            
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // Y座標の計算
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - (topBorder + bottomBorder)
        let maxValue = graphPoints.maxElement() ?? 1
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        let graphPath = UIBezierPath()
        
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
            y:columnYPoint(graphPoints[0])))
    
        
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                                    y:columnYPoint(graphPoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        
        // 折れ線グラフの描画
        // 塗りつぶしと色の設定
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        graphPath.stroke()
        
        // 高さの調整
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        CGContextDrawLinearGradient(context,
                                    gradient,
                                    startPoint,
                                    endPoint,
                                    .DrawsBeforeStartLocation)
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // ドットの描画
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect:
                CGRect(origin: point,
                    size: CGSize(width: 5.0, height: 5.0)))
            
            circle.fill()
        }
        
        let linePath = UIBezierPath()
        
        // 上のラインの描画
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        
        
        // 中央のラインの描画
        linePath.moveToPoint(CGPoint(x:margin,
            y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:graphHeight/2 + topBorder))
        
        
        // 下のラインの描画
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        
        //線の設定
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        //グラフの日付
        var count = 0
        let labelY = width - 1
        for day in graphDays {
            
            let label = UILabel()
            label.text = String(day)
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.systemFontOfSize(9)
            
            //ラベルのサイズを取得
            let frame = CGSizeMake(250, CGFloat.max)
            let rect = label.sizeThatFits(frame)
            
            //ラベルの位置
            var labelX = columnXPoint(count) - 5
            
            label.frame = CGRectMake(labelX, labelY, rect.width, rect.height)
            self.addSubview(label)
            
            count += 1
        }
        
    }
}

