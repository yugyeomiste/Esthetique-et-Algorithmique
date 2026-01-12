//Parametres de base 
void setup() {
  size(640, 400); 
  background(0); 
  // Juste le contour de chaque formes
  noFill(); 
  smooth();
}

void draw() {
  //Efface motif precedent
  noStroke(); 
  //Laisse un effet d'ombre apres chaque rotation
  fill(0,20); 
  rect(0, 0, width, height); 
  
  // On utilise que les contours des formes
  noFill(); 
  //Couleur du motif
  stroke(50, 100, 255,50);
  //Epaisseur du trait fin
  strokeWeight(1); 

  // origine de la rotation au centre
  translate(width/2, height/2); 

  // Interactivite avec la souris 
  float distance = dist(mouseX, mouseY, width/2, height/2);
  float ondes = map(distance, 0, width/2, 2, 12); 

  //Je met le motif a 80% de l'ecran
  float rayonMax = height * 0.40; 
  
  //Trace du motif 10 fois
  for (int j = 0; j < 10; j++) {
     rotate(PI / 3); 
     
     beginShape();
     
     // le tracé se fait en fonction du cercle avec un pas de 0.001
     for (float i = 0; i < TWO_PI; i += 0.001) {
        
       //dimension du motif
        float base = rayonMax * 0.20;
        float ampleur = rayonMax * 0.80;
        //
        float r = base + cos(i * ondes) * ampleur; 
        
        //angle et rayon en postion verticale et horizontale
        float x = r * cos(i);
        float y = r * sin(i);
        vertex(x, y);
     }
     endShape(CLOSE);
  }
}