import java.util.*;

int currentNft = 1;
int numNfts;
String imageBaseUrl = "https://gateway.pinata.cloud/ipfs/QmTqSBM3HAPZXyhfaPmd4AnMGP1gnLuwZBLJAd7HFpmmaG/";

JSONObject json;

void setup()
{
  size(400, 400);
  numNfts = getInt("How many Nft metadata jsons do you need to modify?");
}

void draw() 
{
  if (currentNft <= numNfts) 
  {
    String fileName = String.format("%d.json", currentNft);
    json = loadJSONObject("../NftJsons/" + fileName);
    
    fileName = String.format("%d.png", currentNft);
    String finalName = imageBaseUrl.concat(fileName);
    json.setString("image", finalName);
    
    fileName = String.format("%d.json", currentNft);
    saveJSONObject(json, "../NftJsons/" + fileName);
    currentNft++;
  } else {
    noLoop();
    System.out.println("Editing finished.");
  }
}
