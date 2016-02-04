Import mojo2

Class Fcurve
	
	Const degToRad: Float 	= (PI/180)		'Multiply by this number to convert
	Const radToDeg: Float 	= (180/PI)		'Multiply by this number to convert
	
	Const LINEAR:Int		= 0
	Const HOLD:Int			= 1
	Const COSINE:Int		= 2
	
	Field loop:Bool = False
	
	Private
	
	Field timeline:= New IntMap<Keyframe>
	Field first:Keyframe, last:Keyframe
	Field max:Float, min:Float
	
	Public
	
	Method New( defaultValue:Float )
		AddKnot( defaultValue, 0 )
	End Method
	
	
	Method Get:Float( time:Float )
		If loop Then time = Loop( time, last.time )
		If timeline.Contains( time )
			Return timeline.Get( time ).value
		Else
			Local prv:Keyframe = GetPrevious( time )
			Local nxt:Keyframe = GetNext( time )
			If prv <> nxt		'if they're the same, no need to interpolate. In fact, it causes a division by zero.
				Return Interpolate( prv.value, nxt.value, (time - prv.time) / (nxt.time - prv.time), prv.style )
			Else
				Return prv.value
			End
		End		
	End
	
	
	Method AddKnot:Void( value:Float, time:Int, style:Int=LINEAR )
		Local keyframe := New Keyframe
		keyframe.value = value
		keyframe.time = time
		keyframe.style = style
		timeline.Set(time, keyframe)
		If first
			If keyframe.time < first.time Then first = keyframe
		Else
			first = keyframe
		End
		If last 
			If keyframe.time > last.time Then last = keyframe
		Else
			last = keyframe
		End
		If max
			If keyframe.value > max Then max = keyframe.value
		Else
			max = keyframe.value
		End
		If min
			If keyframe.value < min Then min = keyframe.value
		Else
			min = keyframe.value
		End
	End	
	
	
	Method GetPrevious:Keyframe( time:Int )
		Local temptime:Int = time
		Local current:Keyframe
		For Local k:Keyframe = Eachin timeline.Values()
			If Not current Then current = first	'gets first value
			If k.time < time + 1
				current = k
			End
		Next
		Return current
	End
	
	
	Method GetNext:Keyframe( time:Int )
		Local temptime:Int = time
		Local current:Keyframe
		For Local k := Eachin timeline.Values()
			If k.time > time - 1
				current = timeline.Get(k.time)
				Exit
			End
			current = last	'gets last value
		Next
		Return current
	End
	
	
	Function Interpolate:Float( a:Float, b:Float, x:Float, style:Int=LINEAR )
		Select style
			Case HOLD
				Return a
			Case COSINE
				Local prc:Float = ( 1 - Cos( radToDeg * ( x * PI ) )) / 2
				Return  a * ( 1 - prc ) +  ( b * prc )
			Default 'LINEAR
				Return a * ( 1 - x ) + ( b * x )
		End
	End
	
	
	Method Plot:Void( canvas:Canvas, x1:Float, y1:Float, steps:Int = 1, drawKnots:Bool=True )
	
		Local wx:Float = 0
		Local wy:Float = y1 - Get( 0 )
		
		Repeat
			canvas.DrawPoint( wx + x1, wy )
			wx += steps	
			wy = y1	- Get( wx )
		Until wx >= last.time
				
		If drawKnots
			For Local k:Keyframe = Eachin timeline.Values()
				canvas.DrawCircle( k.time + x1 , y1 - ( k.value ) , 2 )
			Next
		End
		
	End
	
End


Class Keyframe
	Field value:Float
	Field time:Int
	Field style:Int
End


Function Loop:Int(value:Int, duration:Int)		'Loops a value
	If duration > 0
		Return ( value Mod duration )
	Else
		Return value
	End
End

