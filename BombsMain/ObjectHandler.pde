//Page code credit Winand Metz

//Class voor het creëren en opslaan van de objecten
class ObjectHandler {

  //Twee dimensionale float arrays voor spawnrates
  final float enemySpawnChance[][] = new float[6][2];
  final float itemSpawnChance[][] = new float[7][2];

  int eSD = ENTITY_SIZE_DIVIDER;

  //Twee object arraylists voor de game objecten, opgedeeld in muren en entiteiten
  ArrayList<Object> walls =  new ArrayList<Object>();
  ArrayList<Object> entities = new ArrayList<Object>();

  TextureAssets sprites;
  SoundAssets soundAssets;

  ObjectHandler(TextureAssets sprites, SoundAssets soundAssets) {
    this.sprites = sprites;
    this.soundAssets = soundAssets;

    //Vult de spawn rates met de values vanuit config
    for (int i = 0; i < enemySpawnChance.length; i++) {
      enemySpawnChance[i][0] = i;
    }
    enemySpawnChance[0][1] = GHOST_SPAWN_CHANCE;
    enemySpawnChance[1][1] = POLTERGEIST_SPAWN_CHANCE;
    enemySpawnChance[2][1] = SPIDER_SPAWN_CHANCE;
    enemySpawnChance[3][1] = EXPLOSIVE_SPIDER_SPAWN_CHANCE;
    enemySpawnChance[4][1] = MUMMY_SPAWN_CHANCE;
    enemySpawnChance[5][1] = STONED_MUMMY_SPAWN_CHANCE;

    for (int i = 0; i < itemSpawnChance.length; i++) {
      itemSpawnChance[i][0] = i;
    }
    itemSpawnChance[0][1] = BOOTS_DROP_CHANCE;
    itemSpawnChance[1][1] = SPARKLER_DROP_CHANCE;
    itemSpawnChance[2][1] = BLUE_POTION_DROP_CHANCE;
    itemSpawnChance[3][1] = SHIELD_DROP_CHANCE;
    itemSpawnChance[4][1] = CLOAK_DROP_CHANCE;
    itemSpawnChance[5][1] = HEART_DROP_CHANCE;
    itemSpawnChance[6][1] = COIN_DROP_CHANCE;
  }

  //Test code
  //void addEntity(float x, float y, int w, int h) {
  //  x = x + 32;
  //  y = y + 32;

  //  Entity entity = new Entity(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
  //  entities.add(entity);
  //}

  /* Geeft een cijfer dat gebruikt word om te bepalen welke enemy er spawnt
   Neemt een random getal in en kijkt of dit kleiner of groter is dan spawnrates
   Is het groter dan haalt hij de spawnrates eraf net zolang tot hij kleiner is 
   Zodra hij kleiner is telt hij een op en returned dit */
  float getEnemy(float rand) {
    for (int i = 0; i < enemySpawnChance.length; i++) {
      if (rand < enemySpawnChance[i][1]) {
        return enemySpawnChance[i][0] + 1;
      }
      rand -= enemySpawnChance[i][1];
    }
    return 1;
  }

  //Voegt enemy toe aan de entity object list 
  void addEnemy(float x, float y, int w, int h) {
    x = x + 64;
    y = y + 64;

    //Telt alle spawnrates bij elkaar op
    int total = 0;
    for (int i = 0; i < enemySpawnChance.length; i++) { 
      total += enemySpawnChance[i][1];
    }

    //Rand is alle opgetelde spawnrates maal een getal tussen 0 en 1 
    float rand = random(0, 1) * total;
    //Rand wordt doorgegeven aan getEnemy om dit met het weighted system te vertalen naar een cijfer dat gelinkt is aan een vijand
    float enemy = getEnemy(rand);

    //Ghost 
    if (enemy == 1) {
      Ghost ghost = new Ghost(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(ghost);
    }
    //Poltergeist
    if (enemy == 2) {
      Poltergeist poltergeist = new Poltergeist(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(poltergeist);
    }
    //Spider
    if (enemy == 3) {
      Spider spider = new Spider(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD / eSD, this, sprites, soundAssets);
      entities.add(spider);
    }
    //Exp spider
    if (enemy == 4) {
      ExplosiveSpider explosiveSpider = new ExplosiveSpider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(explosiveSpider);
    }
    //Mummy
    if (enemy == 5) {
      Mummy mummy = new Mummy(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(mummy);
    }
    //SMummy
    if (enemy == 6) {
      SMummy sMummy = new SMummy(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(sMummy);
    }
  }

  //Test code
  //void addBreakableObject(float x, float y, int w, int h) {
  //  BreakableObject breakableObject = new BreakableObject(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD / eSD, this, sprites, soundAssets);
  //  entities.add(breakableObject);
  //}

  void addSpider(float x, float y, int w, int h) {
    Spider spider = new Spider(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD / eSD, this, sprites, soundAssets);
    entities.add(spider);
  }

  void addMiniSpider(float x, float y, int w, int h) {
    MiniSpider miniSpider = new MiniSpider(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD / eSD, this, sprites, soundAssets);
    entities.add(miniSpider);
  }

  void addExplosiveSpider(float x, float y, int w, int h) {
    ExplosiveSpider explosiveSpider = new ExplosiveSpider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
    entities.add(explosiveSpider);
  }

  //Method voor het creëren van de muren, input lijkt me vanzelf sprekend
  void addWall(float x, float y, int w, int h) {
    Wall wall = new Wall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    walls.add(wall);
  }

  //Method voor de rockwall onder- en bovenkant van het scherm 
  void addRock(float x, float y, int w, int h) {
    Rock rock = new Rock(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    walls.add(rock);
  }

  void addBreakableWall(float x, float y, int w, int h) {
    BreakableWall breakableWall = new BreakableWall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    walls.add(breakableWall);
  }

  //Method voor plaatsen van de player
  void addPlayer(Highscore highscore) {
    Player player = new Player(PLAYER_X_SPAWN, PLAYER_Y_SPAWN, PLAYER_SIZE / eSD, PLAYER_SIZE, this, sprites, highscore, soundAssets);
    entities.add(player);
    //println("spawned");
  }

  void addFix() {
    CollisionFix fix = new CollisionFix(PLAYER_X_SPAWN, PLAYER_Y_SPAWN - OBJECT_Y_OFFSET, PLAYER_SIZE, PLAYER_SIZE, this, sprites, soundAssets);
    entities.add(fix);
  }

  //Method voor plaatsen van een Bomb
  void addBomb(float x, float y, int w, int h) {
    Bomb bomb = new Bomb(x, y, w, h, this, sprites, soundAssets);
    entities.add(bomb);
  }

  void addC4(float x, float y, int w, int h) {
    C4 c4 = new C4(x, y, w, h, this, sprites, soundAssets);
    entities.add(c4);
  }

  void addLandmine(float x, float y, int w, int h) {
    Landmine landmine = new Landmine(x, y, w, h, this, sprites, soundAssets);
    entities.add(landmine);
  }

  //Method voor plaatsen van een SpiderBomb
  void addSpiderBomb(float x, float y, int w, int h) {
    SpiderBomb spiderBomb = new SpiderBomb(x, y, w, h, this, sprites, soundAssets);
    entities.add(spiderBomb);
  }

  /* Geeft een cijfer dat gebruikt word om te bepalen welke item er spawnt
   Neemt een random getal in en kijkt of dit kleiner of groter is dan spawnrates
   Is het groter dan haalt hij de spawnrates eraf net zolang tot hij kleiner is 
   Zodra hij kleiner is telt hij een op en returned dit */
  float getItem(float rand) {
    for (int i = 0; i < itemSpawnChance.length; i++) {
      if (rand < itemSpawnChance[i][1]) {
        return itemSpawnChance[i][0] + 1;
      }
      rand -= itemSpawnChance[i][1];
    }
    return 1;
  }

  //Voegt enemy toe aan de entity object list 
  void addItem(float x, float y, int w, int h) {

    //Telt alle spawnrates bij elkaar op
    int total = 0;
    for (int i = 0; i < itemSpawnChance.length; i++) { 
      total += itemSpawnChance[i][1];
    }

    //Rand is alle opgetelde spawnrates maal een getal tussen 0 en 1 
    float rand = random(0, 1) * total;
    //Rand wordt doorgegeven aan getItem om dit met het weighted system te vertalen naar een cijfer dat gelinkt is aan een item
    float item = getItem(rand);

    //Boots
    if (item == 1) {
      Boots boots = new Boots(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(boots);
    }
    //Sparkler
    if (item == 2) {
      Sparkler sparkler = new Sparkler(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(sparkler);
    }
    //Blue Potion
    if (item == 3) {
      BluePotion bluePotion = new BluePotion(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(bluePotion);
    }
    //Shield
    if (item == 4) {
      Shield shield = new Shield(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(shield);
    }
    //Cloak
    if (item == 5) {
      Cloak cloak = new Cloak(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(cloak);
    }
    //Heart
    if (item == 6) {
      Heart heart = new Heart(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(heart);
    }
    //Coin
    if (item == 7) {
      Coin coin = new Coin(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(coin);
    }
  }

  void addSpiderQueen(float x, float y, int w, int h) {
    SpiderQueen spiderQueen = new SpiderQueen(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    entities.add(spiderQueen);
  }

  void addMovingWall(float x, float y, int w, int h) {
    MovingWall movingWall = new MovingWall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    entities.add(movingWall);
  }

  //Bepaald een random object
  void addBreakableObject(float x, float y, int w, int h) {
    int randomObject = (int)random(4);

    if (randomObject == 1) {
      Corpse corpse = new Corpse(x, y - OBJECT_Y_OFFSET, w, h / eSD, this, sprites, soundAssets);
      entities.add(corpse);
    }
    if (randomObject == 2) {
      Vases vases = new Vases(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(vases);
    }
    if (randomObject == 3) {
      Backpack backpack = new Backpack(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(backpack);
    }
  }

  void addBullet(float x, float y) {
    Bullet bullet = new Bullet(x, y, 10, 10, this, sprites, soundAssets);
    entities.add(bullet);
  }

  //Method voor verwijderen entity uit entities list
  void removeEntity(Object entry) {
    entities.remove(entry);
  }

  //Method van verwijderen object uit walls list
  void removeWall(Object entry) {
    walls.remove(entry);
  }

  //Updates elke list entry
  void update() {
    ArrayList<Object> entityObjects = entities;
    for (int i = 0; i < entityObjects.size(); i++) {
      if (i >= entityObjects.size()) {
        break;
      }
      entityObjects.get(i).moveMap();
      entityObjects.get(i).update();
    }

    ArrayList<Object> wallObjects = walls;
    for (int i = 0; i < wallObjects.size(); i++) {
      if (i >= wallObjects.size()) {
        break;
      }
      wallObjects.get(i).moveMap();
      wallObjects.get(i).update();
    }
  }

  //Draw voor elk onderdeel in de list en dropshadow voor de entities list
  void draw() {
    ArrayList<Object> entityObjects = entities;
    for (int i = 1; i < entityObjects.size(); i++) {
      if (i >= entityObjects.size()) {
        break;
      }
      entityObjects.get(i).dropShadow();
      entityObjects.get(i).draw();
    }

    entityObjects.get(0).dropShadow();
    entityObjects.get(0).draw();

    ArrayList<Object> wallObjects = walls;
    for (int i = 0; i < wallObjects.size(); i++) {
      if (i >= wallObjects.size()) {
        break;
      }
      wallObjects.get(i).draw();
    }
  }
}
