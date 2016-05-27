
Import fcurve

Function Main:Int()
	New PlotCurve
End


Class PlotCurve Extends App

	Field curve := New Fcurve()
	Field linearCurve := New Fcurve()
	Field adsrCurve := New Fcurve()
	Field loopCurve := New Fcurve()
	Field canvas:Canvas

	Method OnCreate()
		canvas = New Canvas
		
		For Local x:Int = 0 To 600 Step 20
			curve.AddKnot(Rnd( 0,100), x, Fcurve.COSINE )
			linearCurve.AddKnot( Rnd(0,100), x, Fcurve.LINEAR) 
		Next
		
		adsrCurve.AddKnot( 100, 50, Fcurve.LINEAR )
		adsrCurve.AddKnot( 25, 300, Fcurve.LINEAR )
		adsrCurve.AddKnot( 0, 600, Fcurve.LINEAR )
		
		loopCurve.AddKnot( 0, 0, Fcurve.HOLD)
		loopCurve.AddKnot( 20, 50, Fcurve.HOLD)
		loopCurve.AddKnot( 40, 100, Fcurve.HOLD)
		loopCurve.AddKnot( 40, 150, Fcurve.HOLD)
		loopCurve.loop = True
		
		SetUpdateRate( 30 )
	End

	Method OnRender()
		canvas.Clear()
		curve.Plot( canvas, 10, 100 )
		linearCurve.Plot( canvas, 10, 200 )
		adsrCurve.Plot( canvas, 10, 300 )
		loopCurve.Plot( canvas, 10, 400, 1, 600 )
		canvas.Flush()
	End

End