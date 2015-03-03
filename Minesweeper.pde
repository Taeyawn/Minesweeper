import de.bezier.guido.*;
private boolean gameOver = false;
private int NUM_ROWS = 30;
private int NUM_COLS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>();

void setup ()
{
    size(400, 500);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    
buttons = new MSButton[NUM_COLS][NUM_ROWS];
    for(int i = 0; i < NUM_ROWS; i++)
    {
        for(int j = 0; j<NUM_COLS; j++)
        {
            buttons[i][j] = new MSButton(i,j);
        }
    }
    setBombs();
}
public void setBombs()
{
    for(int i = 0; i<=170; i++)
    {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[row][col]))
    {
        bombs.add(buttons[row][col]);
    }
    }
}

public void draw ()
{
}
public boolean isWon()
{
    for(int row=0;row<NUM_ROWS;row++)
    {
        for(int col=0; col<NUM_COLS;col++)
        {
            if(buttons[row][col].isClicked()==false)
            {
                if(!(bombs.contains(buttons[row][col]))) {return false;}
            }
        }
    } 
    return true;
}
public void displayLosingMessage()
{
    stroke(10);
    fill(255);
    for(int i = 0; i < NUM_COLS; i++)
    {
        for(int j = 0; j < NUM_ROWS; j++)
        {
            if(bombs.contains(buttons[i][j]))
            {

                buttons[i][j].clicked = true;
                buttons[i][j].draw();
            }
        }
    }
    text("YOU LOSE", 200, 450);
    noLoop();  
}
public void displayWinningMessage()
{
    fill(0);
    stroke(10);
    text("YOU WIN", 200,450);
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(keyPressed == true)
        {
            marked = !marked;
        }
        else if(bombs.contains(this))
        {
            gameOver = true;
            fill(255);
            displayLosingMessage();
        }
        else if(countBombs(r,c) > 0)
        {
            if(!bombs.contains(this))
            {
            setLabel(""+countBombs(r,c));
            }
        }
        else
        {
            for(int row = r-1; row<=r+1; row++)
            {
                for(int col = c-1; col <= c+1; col++)
                {
                    if(isValid(row,col) && !(buttons[row][col].isClicked()) && !(buttons[row][col].isMarked()))
                    {
                        buttons[row][col].mousePressed();
                    }   
                }
            }
        }
    }

    public void draw () 
    {    
        if(isWon())
        {
            displayWinningMessage();
        }
        if(marked)
        {
            fill(0);
        }
        else if(clicked && bombs.contains(this)) 
        fill(255,0,0);
        else if(clicked)
            fill(200);
        else
        {
            fill(100);
        }

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if((r < 0 || r>NUM_ROWS-1) || (c<0 || c>NUM_COLS-1))
        {
            return false;
        }
        else
        {
        return true;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int r = row-1; r <= row+1; r++)
        {
            for(int c = col-1; c<= col+1; c++)
            {
                if(isValid(r,c))
                {
                    if(bombs.contains(buttons[r][c]))
                    {
                        numBombs++;
                    }
                }
            }
        }
        return numBombs;
    }
}


