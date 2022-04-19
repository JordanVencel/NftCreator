import java.util.*;

int currentNft = 1;
int numNfts, numLayers;
int[] numVariations;
boolean rarityCheck;

String imagesBaseTestUrl = "https://gateway.pinata.cloud/ipfs/boogaaboogaabootest/";
String nftProjectName = "My First NFT Project ";
String externalUrl = "mywebsite.com", description = "I'm testing out the json object class in Processing!";

//Initialize rarity array
ArrayList<Float> rarityArray = new ArrayList<Float>();

//Initialize hashmaps for easy metadata creation
ArrayList<HashMap> layerHashMapArray = new ArrayList<HashMap>();
HashMap<Integer, String> layerNameMap = new HashMap<Integer, String>();

void setup() {
  size(400, 400);
  numNfts = getInt("How many NFTs would you like to create?");
  numLayers = getInt("How many layers do your NFT designs have?");

  //Setup layer names and get number of variations for each layer
  numVariations = new int[numLayers + 1];
  for (int i = 1; i <= numLayers; i++) 
  {
    String layerName = getString(String.format("What is the name of layer #%d", i));
    layerNameMap.put(i, layerName);
    numVariations[i] = getInt(String.format("How many variations does the %s layer have?", layerNameMap.get(i)));
  } 
  layerHashMapArray.add(layerNameMap);

  //Set up variation names
  for (int i = 1; i <= numLayers; i++) 
  {
    HashMap<Integer, String> variationNameMap = new HashMap<Integer, String>();
    for (int j = 1; j <= numVariations[i]; j++) 
    {
      String variationName = getString(String.format("What is the name of variation #%d in the %s layer", j, layerNameMap.get(i)));
      variationNameMap.put(j, variationName);
    } 
    layerHashMapArray.add(variationNameMap);
  }

  //Setup rarity array if needed
  rarityCheck = rarityCheck();
  if (rarityCheck == true) 
  {
    rarityArray.add(0.0);
    for (int i = 1; i <= numLayers; i++) 
    {
      for (int j = 1; j <= numVariations[i]; j++) 
      {
        String rarityGet = String.format("What will be the rarity weight for variation #%d in the %s layer?", j, layerNameMap.get(i));
        float rarityWeight = getFloat(rarityGet);
        rarityArray.add(rarityWeight);
      }
    }
  }
  
}

void draw() {
  if (currentNft <= numNfts) 
  {
    //With rarity do this loop
    if (rarityCheck == true) 
    {
      //Create new JSON object and JSON array which we will fill with attributes and metadata
      JSONObject json = new JSONObject();
      JSONArray attributeArray = new JSONArray();
      //Map rarity weights assigned by user to layer filenames using tree map
      int rarityIndex = 1;
      for (int i = 1; i <= numLayers; i++) 
      {
        float totalWeight = 0.0;
        TreeMap treeMap = new TreeMap<Float, String>();
        for (int j = 1; j <= numVariations[i]; j++) 
        {
          String fileName = String.format("%d-%d", i, j);
          treeMap.put(totalWeight, fileName);
          totalWeight += rarityArray.get(rarityIndex);
          rarityIndex++;
        }
        //Generate a random number and get a filename string out of the tree using the randomly generated number as the key
        Random rand = new Random();
        float num = rand.nextFloat() * totalWeight;
        String fileName = treeMap.floorEntry(num).toString();
        //Split off key and value into two strings, store them in a string array and concatenate file extension.
        String[] myFile = fileName.split("=");
        myFile[1] = myFile[1].concat(".png");
        //Load image using processed filename string
        PImage img = loadImage(myFile[1]);
        image(img, 0, 0);
        //Fill in attribute array with metadata for each layer
        JSONObject attributes = new JSONObject();
        attributes.setString("trait_type", layerHashMapArray.get(0).get(Character.getNumericValue(myFile[1].charAt(0))).toString());
        attributes.setString("value", layerHashMapArray.get(i).get(Character.getNumericValue(myFile[1].charAt(2))).toString());
        attributeArray.setJSONObject(i - 1, attributes);
      }
      String finalFileName = String.valueOf(currentNft);
      //Add more metadata to json
      json.setString("description", description);
      json.setString("external_url", externalUrl);
      json.setString("image", imagesBaseTestUrl + finalFileName + ".png");
      json.setInt("tokenId", currentNft);
      json.setString("name", nftProjectName.concat(finalFileName));
      json.setJSONArray("attributes", attributeArray);
      //Save json, take a snapshot of canvas and clear for next nft
      saveJSONObject(json, "NftJsons/" + finalFileName + ".json");
      saveFrame("NftPngs/" + finalFileName + ".png");
      background(255);


      currentNft++;
    } else {
      //Without rarity do this more simple thing
      for (int i = 1; i <= numLayers; i++) 
      {
        //Generate random number
        int variationNum = (int) ceil(random(0, numVariations[i]));
        //Use random number to generate filename string
        String fileName = String.format("%d-%d.png", i, variationNum);
        //Load an image using randomly generated filename
        PImage img = loadImage(fileName);
        image(img, 0, 0);
      }
      String finalFileName = String.valueOf(currentNft);
      //Take snapshot once layers are laid down and clear canvas
      saveFrame("NftPngs/" + finalFileName + ".png");
      background(255);
      currentNft++;
    }
  } else {
    noLoop();
  }
}
