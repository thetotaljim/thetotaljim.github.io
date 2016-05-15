/*	
 * 
 * James Steimel	Assignment 6	Minesweeper		2261
 * 
 */



import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Application;		//	Needed to extend Application
import javafx.stage.Stage;					//	Next two needed for start() override
import javafx.util.Duration;
import javafx.scene.Scene;					
import javafx.scene.layout.GridPane;		//	Needed for GridPane pane = new GridPane
import javafx.scene.paint.Color;
import javafx.geometry.Pos;					//	Needed for .setAlignment(Pos.CENTER)
import javafx.scene.layout.*;				// 	Used for several things, like BorderPane
import javafx.scene.control.*;
import javafx.geometry.Insets;
import javafx.event.*;
import java.util.Random;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;


public class MySweeper extends Application{

	// private class constant and some variables
    private static final Integer STARTTIME = 0;
    private Timeline timeline;
    private Label timerLabel = new Label();
    private Integer timeSeconds = STARTTIME;
	
	
	//	Simple function to generate random integers.
	
	public int getRandomInt(){
		int retVal = 0;
		Random rand = new Random();
		retVal = rand.nextInt(16);
		return retVal;
	}
	
	//	Simple function to check bounds.
	
	public boolean checkBounds(int x, int y){
		if ( x < 0 || x > 15 || y < 0 || y > 15){
			return false;
		}
		else
			return true;
	}
		
	@Override
	public void start(Stage primaryStage) {
		
		

		/*	Declarations for BorderPane and the GridPane that will be 
		 * 	set into the BorderPane.
		 */
		
		BorderPane bPane = new BorderPane();
		GridPane grid = new GridPane();
		grid.setAlignment(Pos.CENTER);
		
		
		
/*		grid.setOnMouseDragged(new EventHandler<MouseEvent>(){
		    @Override
		    public void handle(MouseEvent t) {
		    if(t.getButton() == MouseButton.PRIMARY) f1();
		    if(t.getButton() == MouseButton.SECONDARY) f2();
		    }
		});    */
		
		/*	Array of MineButtons is declared, along with some 
		 * 	other variables 
		 */
		
		MineButton[][] mineButtons = new MineButton[16][16];
		
		Button start = new Button("Start");
	    start.setPrefSize(100, 20);
	    
	    //	Start button EventHandler.
	    
	    start.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
            		
            	if (timeline != null) {
                    timeline.stop();
                }
              //      timeline.stop();
                    timerLabel.setText("0");
                    
                    
                
            	setBoard(grid, mineButtons); 
            }
	    });
	
		/*	The setBoard method will populate the MineButton[][], then
		 * 	it will assign bombs to random locations, and finally it will
		 * 	add the individual MineButtons to the GridPane.
		 * 
		 */
		setBoard(grid, mineButtons);
	
		
Button timer = new Button("Click Here to Start Timer");
	    
	    
	  timerLabel.setText(timeSeconds.toString());
      timerLabel.setTextFill(Color.WHITE);
      timerLabel.setStyle("-fx-font-size: 2em;");
 //       timerLabel.setStyle("-fx-font: 22 arial; -fx-base:#dcdcdc;");
      timerLabel.setPrefSize(100, 20);
        
      timer.setOnAction(new EventHandler<ActionEvent>() {
        	 
    	  public void handle(ActionEvent event) {
            // Button event handler code goes here . . .
            	if (timeline != null) {
                    timeline.stop();
                }
                timeSeconds = STARTTIME;
         
                // update timerLabel
                timerLabel.setText(timeSeconds.toString());
                timeline = new Timeline();
                timeline.setCycleCount(Timeline.INDEFINITE);
                timeline.getKeyFrames().add(
                        new KeyFrame(Duration.seconds(1),
                          new EventHandler<ActionEvent>() {
                            // KeyFrame event handler
                            public void handle(ActionEvent event) {
                                timeSeconds++;
                                // update timerLabel
                                timerLabel.setText(
                                      timeSeconds.toString());
                                if (timeSeconds >= 999) {
                                    timeline.stop();
                                }
                              }
                        }));
                timeline.playFromStart();
            }
            	
            	
            
        });
		
		
		
		Label lblStatus = new Label("");
		bPane.setCenter(grid);
		bPane.setBottom(lblStatus);
		
		/*	
		 * Use Hbox to have two horizontal boxes for Start and Show 
		 * 
		 */
		
		HBox hbox = new HBox();
	    hbox.setPadding(new Insets(15, 12, 15, 12));
	    hbox.setSpacing(10);
	    hbox.setStyle("-fx-background-color: #336699;");
	    
	    /*
	     * 	And here are the buttons.
	     */
	    
	    //	Start button.
	    
	    
	    
	    
	    

	    Button show = new Button("Show");
	    show.setPrefSize(100, 20);
	    hbox.getChildren().addAll(start, show, timer, timerLabel);
	    
	    //	EventHandler for the Show button.
	    
	    show.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
            	for( int row1 = 0; row1 < 16; row1++){
        			for ( int col1 = 0; col1 < 16; col1++){
        				if (mineButtons[row1][col1].isAMine() == true){
        						
        					mineButtons[row1][col1].setText("B");
        					
        					mineButtons[row1][col1].setText("");
		                	Image imageOk2 = new Image(getClass().getResourceAsStream("bomb.png"));
		//                	imageOk.fitWidthProperty().bind(scrollpane_imageview1.widthProperty()); 
		                	ImageView image2 = new ImageView();
		                    image2.setImage(imageOk2);
		                    image2.setFitHeight(20);
		                    image2.setFitWidth(20);
		                    Button here = new Button();
		                    here = (Button)mineButtons[row1][col1];
		                	here.setGraphic(image2);
		                	mineButtons[row1][col1] = (MineButton)here;
        					
        				}
        			}
        		}
            }
	    });
	    
	    
	    
	    
	    
	    
	    /*	
	     * 	Now the HBox buttons are set in the top of the BorderPane
	     */
	    bPane.setTop(hbox);
		
	    /*	
	     * 	Now the BorderPane is set into the Scene.
	     */
	    
		Scene scene = new Scene(bPane, 800, 800);
		primaryStage.setTitle("Minesweeper");
		primaryStage.setScene(scene);
		primaryStage.show();
		
		
	}
	
	/*	
	 * 	This function will check all the cells around the specified cell for 
	 * 	bombs, and then total the number that are found and return it to the 
	 * 	user.
	 * 
	 */
	
	public int getNumOfSurroundingBombs(MineButton [][] array, int x, int y){
		int sum = 0;
		
		for ( int r = -1; r < 2; r++){
			for ( int c = -1; c < 2; c++){
				
				boolean value = checkBounds(x+r, x+r);
				boolean values = checkBounds(y+c, y+c);
				
				if( values == true && value == true){
					if( array[x+r][y+c].isAMine() == true ){
					sum++;
					}
				}
			}
		}	
		
		return sum;
	}
	
	public void recursion(MineButton[][] mineButtons, int x, int y){
		
		int flag = 0;
		
		/*	This will check and see if the button being checked is 
		 * 	within the bounds of the board. If not, It will exit the method.
		 * 	It also will check to make sure that I haven't already looked at that square.
		 * 	
		 */
		
		if ( x > 15 || x < 0 || y > 15 || y < 0 || mineButtons[x][y].isNumberSet() == true ){
			return;
		}
		
		/*	If the button being checked is within bounds, and has not already been checked...
		 */
		
		else{
			
			//	Flag gets set to the number of bombs surrounding a particular cell.
			
			flag = getNumOfSurroundingBombs(mineButtons, x, y);
			
			/*	If there are any bombs surrounding it, their total number is set onto the button
			 * 	and that part of the recursive loop will end.
			 */
			
			if (flag > 0 && mineButtons[x][y].isAMine() == false){
				mineButtons[x][y].setText(String.valueOf(flag));
				return;
			}	
			
			/*	If there are no bombs adjacent to this cell, then the recursive function is called
			 * 	for each cell adjacent to it as long as they are within the bounds of the 
			 * 	game board and as long as they have not already been checked.
			 */
			
			else if (flag == 0){
				
				//	Set the text on the button to " " to designate it has been cleared and has no 
				//	adjacent bombs.
				
				mineButtons[x][y].setText(" ");
				mineButtons[x][y].setStyle("-fx-font: 22 arial; -fx-base:#90ee90;");
				


				
				mineButtons[x][y].numberSet();
				
				//	For loop runs through the cells surrounding it.
				
				for ( int r = -1; r < 2; r++){
					for (int c = -1; c < 2; c++){
						
						/*	
						 * 	Make sure no points are out of bounds.
						 */
						
						
						
						boolean value = checkBounds(x+r, x+r);
						boolean values = checkBounds(y+c, y+c);
						
						//	If the X and Y are in bounds...
						
						if ( value == true && values == true){	
						
							//	And if it is a square I have not checked yet...
							
						if ( mineButtons[x+r][y+c].isNumberSet() == false ){
								
								//	The recursive function is called.
	//						mineButtons[x][y].setText(" ");
		//					mineButtons[x][y].numberSet();
								recursion (mineButtons, x+r, y+c);
							}
						}				
					}
				}
			}
		}
	}
	
	/*	
	 * This is my custom button class MineButton.	It has some
	 * 	extra values, like an x and y position on the board, as
	 * 	well as boolean values to track whether it is a bomb and
	 * 	whether it already has been checked and set. 
	 * 
	 */
	public class MineButton extends Button{
		private boolean isMine = false;
		private boolean numberIsSet = false;
		private int x = 0;
		private int y = 0;
		
		public MineButton(int row, int col){
			super();
			setX(row);
			setY(col);
		}
		
		public void numberSet(){
			numberIsSet = true;
		}
		
		public boolean isNumberSet(){
			return numberIsSet;
		}
		
		public int getX(){
			return x;
		}
		
		public int getY(){
			return y;
		}
		
		public void setX(int X){
			x = X;
		}
		
		public void setY(int Y){
			y = Y;
		}
		
		public boolean isAMine(){
			return isMine;
		}
		
		public void setMine(boolean val){
			isMine = val;
		}
	}
	
	
	
	/*	
	 * This method sets up the board by creating a 2D array of MineButtons, 
	 * 	assigning event handling to each button, and then adding each button 
	 * 	in the array to the GridPane.
	 */
	
	public void setBoard(GridPane grid, MineButton [][] mineButtons){
		
		//	Variable Declarations.
		
		int val = 0, val2 = 0, numPlaced = 0;
		boolean keepPlacingMines = true;
		boolean minesPlaced = false;
		
		/*	A mine button will now be created for each cell in the 8x8 grid that is the 
		 * 	game board.  It will be set to a size, and it's text display will be set. 
		 * 	
		 */
		
		for (int row = 0; row < 16; row++){
			for (int col = 0; col <16; col++){
				
				MineButton button = new MineButton(row, col);
				button.setPrefSize(75, 75);
				button.setText("?");
				button.setStyle("-fx-font: 22 arial; -fx-base:#dcdcdc;");
				
				/*	Each button has the same EventHandler. If a button is pressed and it
				 * 	is a mine, it's text display is set to B for bomb, and all other bombs
				 * 	are also displayed with a B. If it is not a bomb, the recursive function 
				 * 	is called on it.
				 */
				

				button.addEventFilter(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {
		            @Override
		            public void handle(MouseEvent event) {
		                if(event.getButton() == MouseButton.SECONDARY){
//		                  Type code to set flag here
		                //	button.setText("B");
		                	
		                	
		                	button.setText("");
		                	Image imageOk = new Image(getClass().getResourceAsStream("grumpy.png"));
		//                	imageOk.fitWidthProperty().bind(scrollpane_imageview1.widthProperty()); 
		                	ImageView image = new ImageView();
		                    image.setImage(imageOk);
		                    image.setFitHeight(20);
		                    image.setFitWidth(20);
		                	button.setGraphic(image);
		                	
		                	button.setStyle("-fx-font: 22 arial; -fx-base: #ffd700;");
		                	button.numberSet();
		                	
		                }
		            }
		        });
				
				
				button.setOnAction(new EventHandler<ActionEvent>() {
		            @Override
		            public void handle(ActionEvent event) {
		            	
		            	if ( button.isAMine() == true){
		            		button.setText("B");
		            		Image imageOk = new Image(getClass().getResourceAsStream("bomb.png"));
				    		//                	imageOk.fitWidthProperty().bind(scrollpane_imageview1.widthProperty()); 
				    		                	ImageView image = new ImageView();
				    		                    image.setImage(imageOk);
				    		                    image.setFitHeight(20);
				    		                    image.setFitWidth(20);
		            		button.setGraphic(image);
		            		
		            		for( int row1 = 0; row1 < 16; row1++){
		            			for ( int col1 = 0; col1 < 16; col1++){
		            				
		            				if (mineButtons[row1][col1].isAMine() == true){
		            					mineButtons[row1][col1].setText("B");
		            					
		            					mineButtons[row1][col1].setText("");
		    		                	Image imageOk2 = new Image(getClass().getResourceAsStream("bomb.png"));
		    		//                	imageOk.fitWidthProperty().bind(scrollpane_imageview1.widthProperty()); 
		    		                	ImageView image2 = new ImageView();
		    		                    image2.setImage(imageOk2);
		    		                    image2.setFitHeight(20);
		    		                    image2.setFitWidth(20);
		    		                    Button here = new Button();
		    		                    here = (Button)mineButtons[row1][col1];
		    		                	here.setGraphic(image2);
		    		                	mineButtons[row1][col1] = (MineButton)here;
		            					
		            					mineButtons[row1][col1].setStyle("-fx-font: 22 arial; -fx-base: #dc143c;");
		            				}
		            			}
		            		}
		            	}
		            	else{
		            		
		            		recursion(mineButtons, button.getX(), button.getY());
		            		
		            	}     	
		            }	
		          
		            
				});	
			
				/*	Here I add each new button to the MineButton 2D array, as 
				 * 	well as the GridPane that will be set into my BorderPane.
				 */
				
				mineButtons[row][col] = button;
				grid.add(button, row, col);
			}
		}
		
		/*	In this do/while loop, 8 bombs are placed in random cells on the 
		 * 	game board.
		 */
		
		do{
			val = getRandomInt();
			val2 = getRandomInt();
			
			minesPlaced = mineButtons[val][val2].isAMine();

			if (minesPlaced == false){
				mineButtons[val][val2].setMine(true);
				numPlaced++;
			}
			
			if (numPlaced >= 16){
				keepPlacingMines = false;
			}
					
		}while( keepPlacingMines == true);
	}
	
	 
	
	/*	
	 *  Main	
	 *  
	 */
	
	public static void main(String[] args) {
		Application.launch(args);
	}

}


