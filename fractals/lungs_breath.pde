// Projet du 14/01 simulation de la respiration des poumons 
// THEME: Fractales

void setup() {
  size(800, 600); 
  smooth();
}

void draw() {
  background(255); 
  
  // Intéraction verticale
  float gonflement = map(mouseY, 0, height, 0, 1);
  gonflement = constrain(gonflement, 0, 1);

  translate(width/2, 140);
  
  // Trachée
  
  strokeWeight(12); 
  stroke(255, 80, 80);
  line(0, 0, 0, 100); 
  translate(0, 100); 
  
  // Angle
  float angle = radians(40 + (gonflement * 25));
 
  float longueur = 80 + (gonflement * 40);
  
  // Symetrie
  
  // Poumon Gauche
  pushMatrix();
  rotate(angle);
  genererFractale(longueur, 10, gonflement); 
  popMatrix();
  
  // Poumon Droit 
  pushMatrix();
  rotate(-angle);
  genererFractale(longueur, 10, gonflement);
  popMatrix();
}

// Fractale
void genererFractale(float h, float ep, float infl) {
  
  strokeWeight(ep);
  line(0, 0, 0, h);
  translate(0, h);
  
  h *= 0.70;
  ep *= 0.70;
  
  // Condition d'arret 
  if (h >1) { 
    
    float angleInterne = radians(25 + (infl * 15));
    
    // Poumons droit
    pushMatrix();
    rotate(angleInterne);
    genererFractale(h, ep, infl);
    popMatrix();
    
    // Poumons gauche
    pushMatrix();
    rotate(-angleInterne);
    genererFractale(h, ep, infl);
    popMatrix();
    
    // Branche centrale 
    if (h > 15) { 
       pushMatrix();
       genererFractale(h * 0.5, ep * 0.8, infl);
       popMatrix();
    }
  }
}