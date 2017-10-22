//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  03-03-2017                               --
//                                                                       --
//    Spring 2017 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY,       // Ball coordinates
                                          BallS,              // Ball size (defined in ball.sv)
                                          DrawX, DrawY,       // Coordinates of current drawing pixel
														RocketX, RocketY,
														RocketS,
														MonsterX, MonsterY,
														MonsterS,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    
    logic ball_on, rocket_on, monster_on, destroy_on;
    logic [7:0] Red, Green, Blue, SPRITE, _Red, _Green, _Blue;
     
 /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
    the single line is quite powerful descriptively, it causes the synthesis tool to use up three
    of the 12 available multipliers on the chip! Since the multiplicants are required to be signed,
    we have to first cast them from logic to int (signed by default) before they are multiplied. */
      
    int DistX, DistY, BallSize, DistRocketX, DistRocketY, RocketSize, MonsterSize;
    //assign DistX = DrawX - BallX;
    //assign DistY = DrawY - BallY;
    assign BallSize = BallS;
    
	 assign DistRocketX = DrawX - RocketX;
	 assign DistRocketY = DrawY - RocketY;
	 assign RocketSize = RocketS; 
	 
	 assign MonsterSize = MonsterS;
	 
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Compute whether the pixel corresponds to ball or background

	ColorTable 	Color	(.color(ColorNumber),
				.DrawX,
				._Red,
				._Green,
				._Blue
				);


	SpriteTable	Sprite	(.Sprite(/*Something*/)
				.DrawX,
				.Drawy,
				.color(ColorNumber)
`				);


	
    always_comb
    begin : Ball_on_proc
        if ( (DrawX + (BallSize/2) >= BallX) && (DrawX <= (BallX + (BallSize/2))) && (DrawY + (BallSize/2) >= BallY) && (DrawY <= (BallY + (BallSize/2)))) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
    end
    
	 always_comb
	 begin : Rocket_on_proc
			if(((DistRocketX*DistRocketX) + (DistRocketY*DistRocketY)) <= (RocketSize*RocketSize))
				rocket_on = 1'b1;
			else
				rocket_on = 1'b0;
	 end
	 
	 always_comb
    begin : Monster_on_proc
        if ( (DrawX + (MonsterSize/2) >= MonsterX) && (DrawX <= (MonsterX + (MonsterSize/2))) && (DrawY + (MonsterSize/2) >= MonsterY) && (DrawY <= (MonsterY + (MonsterSize/2)))) 
            monster_on = 1'b1;
        else 
            monster_on = 1'b0;
    end
    
	 always_comb
    begin : Destroy_on_proc
        if (((RocketY <= (MonsterY + MonsterSize/2)) && (RocketY + (MonsterSize/2) >= MonsterY)) && ((RocketX <= (MonsterX + MonsterSize/2)) && (RocketX + (MonsterSize/2) >= MonsterX)) ) 
            destroy_on = 1'b1;
        else 
            destroy_on = 1'b0;
    end
	 
    // Assign color based on ball_on signal
    always_comb
    begin : RGB_Display
        if ((ball_on == 1'b1)) 
        begin
            // White ball
            Red = 8'h3c;
            Green = 8'h2d + {1'b0, DrawY[9:3]};
            Blue = 8'h00 + {1'b0, DrawX[9:3]};
        end
		  else if(destroy_on == 1'b1)
		  begin
				Red = 8'hff;
				Green = 8'ha5;
				Blue = 8'h00;
		  end
        else if (rocket_on == 1'b1)
		  begin
				Red = 8'h4d;
				Green = 8'h00;
				Blue =  8'h1c;
		  end
		  else if (monster_on == 1'b1)
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff;
		  end
		  else 
        begin
            // Background with nice color gradient
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;// + {1'b0, DrawX[9:3]};
        end
    end

endmodule
