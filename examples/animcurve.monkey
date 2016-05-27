
Import fcurve

Function Main:Int()
	New AnimCurve
End


Class AnimCurve Extends App

	Field curve := New Fcurve()
	Field canvas:Canvas

	Method OnCreate()
		canvas = New Canvas
		
		'The curve will be 10 seconds long, with 4 new knots per second
		For Local time:Int = 0 To 10000 Step 250				
			curve.AddKnot( Rnd( 0, DeviceHeight/2 ), time, Fcurve.COSINE )
		Next
		curve.loop = True
		
		SetUpdateRate( 30 )
	End

	Method OnRender()
		canvas.Clear()
		
		'here's where the magic happens. Get the current value from the curve, and loops every 10000 millisecs.
		Local y := curve.Get( Millisecs() )
		canvas.DrawCircle( DeviceWidth/2, ( DeviceHeight*3 )/4 - y , DeviceHeight/10 )
		
		canvas.Flush()
	End

End