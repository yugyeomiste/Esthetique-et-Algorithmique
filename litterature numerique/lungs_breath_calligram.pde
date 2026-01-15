// Projet J4 : Calligram Lungs Breath
// Poeme trouvé sur un site de poeme (https://hellopoetry.com/tags/lungs) 


String poemeTexte = "Came to see if I was breathing, I’m just needing a moment to calm down. It’s just me still caged in this grieving a sinking feeling causing me to drown. Regardless of the gasping it never stops; the question asking, and my own answers are lacking go ahead and tell ‘em, Long Lungs. Hand over mouth in surprise and despair, preventing fact from making a great escape. A single breath couldn’t start to prepare the never ending lines of caution tape. Ignoring all of the many problems, resigned to never solve them, no one offers help so why involve them? Go ahead and tell ‘em, Long Lungs. I’ve been screaming silently most of my life. Echoing pain and torment for endless miles. Questioning visible scars while holding the knife, that caused the death of seriousness and birthed countless smiles. Came to see if I could tell or show and speak the words I could never know, while my grip weakens so I let it go, and hope whatever falls can regrow. Go ahead and tell ‘em Long Lungs. Through all of the many seasons they stopped changing and started bleedin’ I don’t judge’ cause I’m sure they have their reasons. Go ahead and tell ‘em Long Lungs.";

String[] mots; 
PFont police;

// J'ajoute une pause pour pouvoir lire
boolean enPause = false;
float tempsAnim = 0;

void setup() {
  size(800, 700);
  smooth();
  mots = split(poemeTexte, " ");
  police = createFont("IndieFlower-Regular.ttf", 40);
  textFont(police);
  
  if (police == null) police = createFont("Helvetica", 40); 
  
  textFont(police);
}


void draw() {
  background(255); 
  fill(0); 
  noStroke();

  //Gestion de la pause 
  if (enPause == false) {
    tempsAnim += 0.03; 
  }
  //Titre
  textAlign(CENTER, TOP); 
  textSize(28); 
  text("Long Lungs", width/2, 40);
  
  textSize(16); 

  float debutSeparation = 150; 

  //Simulation de la respiration
  float cycle = sin(tempsAnim); 
  float largeurPoumon = map(cycle, -1, 1, 120, 220);

  int indexMot = 0; 
  float y = 100;     
  float interligne = 16; 
  
  while (y < height - 50 && indexMot < mots.length) {
    
    if (y < debutSeparation) {
      //Trachée
      float largeurTrachee = 50; 
      float xDebut = width/2 - largeurTrachee/2;
      float xFin = width/2 + largeurTrachee/2;
      
      indexMot = remplirLigne(indexMot, xDebut, xFin, y, true);
      
    } else {
      //Poumons 
      float progression = (y - debutSeparation) / 350.0;
      progression = constrain(progression, 0, PI);
      
      float courbe = sin(progression * 2.5) * largeurPoumon; 
      float ecartCentre = 20 + (progression * 80); 

      float xFinG = width/2 - ecartCentre;
      float xDebutG = xFinG - courbe - 40; 
      
      float xDebutD = width/2 + ecartCentre;
      float xFinD = xDebutD + courbe + 40;
      
      // Remplissage
      indexMot = remplirLigne(indexMot, xDebutG, xFinG, y, false); 
      indexMot = remplirLigne(indexMot, xDebutD, xFinD, y, true);  
    }
    
    y += interligne; 
  }
  
  // Instructions pour le lecteur
  fill(0);
  textSize(12);
  textAlign(LEFT, BOTTOM);
  if (enPause) {
    text("PAUSE (ESPACE pour reprendre le respiration)", 10, height - 10);
  } else {
    text("ESPACE pour lire le poeme", 10, height - 10);
  }
}

// Interactivité
void keyPressed() {
  if (key == ' ') {
    enPause = !enPause; 
  }
}

//Affichage
int remplirLigne(int index, float x1, float x2, float y, boolean alignLeft) {
  if (index >= mots.length) return index;
  
  float largeurDispo = x2 - x1;
  String ligneAffiche = "";
  float largeurActuelle = 0;
  int tempIndex = index;
  
  // On calcule quels mots rentrent dans la ligne
  while (tempIndex < mots.length) {
    String mot = mots[tempIndex];
    float w = textWidth(mot + " ");
    if (largeurActuelle + w > largeurDispo) break;
    ligneAffiche += mot + " ";
    largeurActuelle += w;
    tempIndex++;
  }
  
  // On dessine toute la ligne d'un coup
  fill(0);
  if (largeurActuelle > 0) {
    if (alignLeft) {
      textAlign(LEFT, TOP);
      text(ligneAffiche, x1, y);
    } else {
      textAlign(RIGHT, TOP); 
      text(ligneAffiche, x2, y);
    }
  }
  return tempIndex; 
}