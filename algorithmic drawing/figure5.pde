//J'ai repris le code de base

void setup() {
  size(640, 400);
  background(255); // Fond blanc
  stroke(0);   // Lignes noirs
  noFill();
  noSmooth();
}

void draw() {
  
  background(255); // Fond blanc
  //A=Xrsl%/2
  //B=Yrsl%/2
  int Xrsl=640;
  int Yrsl=400;
  
  int a = Xrsl/2;
  int b = Yrsl/2;
  
  
  for (int i = 1; i < 2; i++) {
  
  // R=Yrsl%*0.7
  float r = height * 0.7; 

  //For W=Pi/4 To 3.6 Step 0.05
  for (float w = PI/4; w < 3.6; w += 0.05) {
    
    //X=R*Cos(W)
    //Y=R*Sin(W)
    float x = r * cos(w);
    float y = r * sin(w);
    
    // j'utilise la fonction qui repere la position de la souris
    float d = dist(mouseX, mouseY, a+x, b-y);
    
    if (d < 40) {
      stroke(118, 23, 255); // couleur si la souris touche
      strokeWeight(2);   // Plus épais
    } else {
      stroke(0);         // noir sinon
      strokeWeight(1);
    }
    
    // voir lignes code Line A+X,B-Y,A-Y,B-X
    line(a+x, b-y, a-y, b-x);
    line(a-y, b-x, a-x, b+x);
    line(a-x, b+y, a+x, b-y);
    line(a-x, b+y, a+y, b+x);
    line(a+y, b+x, a+x, b-y);
    
    //R=R*0.94
    r = r * 0.94;
  }
    
  }
}