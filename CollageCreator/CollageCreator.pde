import javax.swing.*;

int numNfts;
int currentNft = 1;
int xCor = 0, yCor = 0;

void setup()
{
  size(4000,2400);
  numNfts = getInt("How many nfts will be in the collage?");
  noLoop();
}

void draw()
{
   for (int i = 0; i <= 3600; i += 400)
   {
     for (int j = 0; j <= 2000; j += 400)
     {
       String imageName = String.format("../NftPngs/%d.png", currentNft);
       PImage image = loadImage(imageName);
       image(image, i, j);   
       currentNft++;
     }
   }
   saveFrame("collage.png");
   System.out.println("Collage completed!");
}

int getInt(String s) {
  return Integer.parseInt(getString(s));
}

String getString(String s) {
  return prompt(s);
}

String prompt(String s) {
  println(s);
  String entry = JOptionPane.showInputDialog(s);
  if (entry == null)
    return null;
  println(entry);
  return entry;
}
