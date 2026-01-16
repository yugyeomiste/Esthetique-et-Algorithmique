// Projet libre : UZUMAKI inspired by Junji Ito

// 50k de particules pour avoir un tracé qui ressemble a une spirale
int nbParticules = 50000; 
ArrayList<Particule> particules;

//Variables pour gérer l'animation
float etape = 0;        // Etapes (0 = coquillage, 1 = spirale)
float cibleEtape = 0;   // Ou on va quand on clic
float temps = 0;        // Pour faire bouger le bruit (noise)
float GOLDEN_B = 0.306349; // Constante de la spirale d'or 
float angleRotation = 0;   

// Taille de l'oeil
float rayonOeil = 280; 

void setup() {
  size(600, 600);
  frameRate(80); 
  
  // Liste de points
  particules = new ArrayList<Particule>();
  for (int i = 0; i < nbParticules; i++) {
    particules.add(new Particule(i));
  }
  
  noStroke();
}

void draw() {

  fill(20, 100); 
  rect(0, 0, width, height);
  
  temps += 0.01; // Le temps avance pour l'animation
  
  etape = lerp(etape, cibleEtape, 0.02); 
  
  //Accéleration de la rotation en fonction des clics
  float vitesse = 0.01 + (etape * 0.08);
  angleRotation += vitesse;
  
  // Centre
  translate(width/2, height/2);

  // Oeil 
  fill(235); noStroke();
  ellipse(0, 0, rayonOeil * 2, rayonOeil * 2);
  
  noFill();
  for (float r = rayonOeil; r > rayonOeil - 80; r-=2) {
    float alpha = map(r, rayonOeil - 80, rayonOeil, 0, 100);
    stroke(0, 0, 20, alpha); 
    ellipse(0, 0, r*2, r*2);
  }
  noStroke(); 

  //Spirale
  pushMatrix(); // Pour faire tourner que les particules
  rotate(angleRotation);
 
  for (Particule p : particules) {
    p.update(etape);
    p.display();
  }
  popMatrix(); //Rotation normale
}


//Interactivité

// Chaque clic accélere la rotation
void mousePressed() {
  cibleEtape += 0.25; 
}

// ESPACE pour Reset 
void keyPressed() {
  if (key == ' ') 
  cibleEtape = 0; 
}

//Particule

class Particule {
  int index;         // Le numéro de la particule
  PVector pos;       // Ou elle est vraiment
  PVector cible;     // Ou elle doit aller
  float taille;
  float uniqueID;
  
  Particule(int i) {
    index = i;
    pos = new PVector(0, 0);
    cible = new PVector(0, 0);
    taille = 1.8; 
    uniqueID = random(1000); 
  }
  
  void update(float progression) {
    
    //Nautilus Shell
    //J'utilise l'index pour placer les points le long d'une courbe
    float tNorm = map(index, 0, nbParticules, 0, 1);
    float angleShell = tNorm * 6 * PI; 
    
    //Mouvement du coquillage
    float mouv = 1.0 + (sin(frameCount * 0.05) * 0.02 * (1-progression));
    
    // Formule mathématique de la spirale (trouvé sur internet)
    float rayonShell = (6 * exp(GOLDEN_B * angleShell)) * mouv; 
    
    // J'ajoute un peu bruit la ligne est trop fine
    if (progression < 0.5) {
       rayonShell += sin(angleShell * 10) * (6 * (1-progression)); 
    }
    
    // Conversion en coordonnées X/Y 
    float x1 = (cos(angleShell) * rayonShell) - 40; 
    float y1 = (sin(angleShell) * rayonShell) + 50;
    
    float tours = 85.0; // Je fais beaucoup de tours pour remplir l'oeil
    float angleMax = TWO_PI * tours;
    
    float angleSpirale = map(index, 0, nbParticules, 0, angleMax);
    
    float ecartement = 0.55; 
    
    float rayonSpirale = ecartement * angleSpirale;
    
    float x2 = cos(angleSpirale) * rayonSpirale;
    float y2 = sin(angleSpirale) * rayonSpirale;

    // Je regroupe les deux (Coquillage & Spirale)
    float mix = constrain(progression, 0, 1);
    
    // La fonction lerp calcule le point intermédiaire (aide de l'IA)
    float finalX = lerp(x1, x2, mix);
    float finalY = lerp(y1, y2, mix);
    
    cible.set(finalX, finalY);
    

    // J'ai voulu créer un effet qui tremble 
    float facteurChaos = (1.0 - mix); 
    
    if (facteurChaos > 0.01) {
      float bruitX = noise(cible.x * 0.01 + uniqueID, temps) - 0.5;
      float bruitY = noise(cible.y * 0.01 + uniqueID, temps + 100) - 0.5;
      
      cible.x += bruitX * (20 * facteurChaos);
      cible.y += bruitY * (20 * facteurChaos);
    }
   
    pos.x += (cible.x - pos.x) * 0.15; 
    pos.y += (cible.y - pos.y) * 0.15;
  }
  
  void display() {
    //Les points sont dessinés uniquement dans l'oeil
    if (dist(pos.x, pos.y, 0, 0) > rayonOeil - 2) return;
    
    fill(0, 240);
    ellipse(pos.x, pos.y, taille, taille);
  }
}