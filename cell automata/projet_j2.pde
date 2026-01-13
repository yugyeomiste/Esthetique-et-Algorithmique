// Projet du 13/01 explosion du BIGBANG

int size = 2; // Taille des cellules
int cols, rows;
int[][] grid;      // grille actuelle
int[][] nextGrid;  // grille suivante 

// Variables Explosion
boolean explosion = false;
float radius = 0;      // Taille du cercle
float speed = 1.8;     // Vitesse
float density = 0.1;   // Nombre d'etoiles sur la sphere

// Variable pour la transition de couleur
float colorchange = 0; 

// Forme des etoiles avc 0 = vide / 1 = plein
int[][][] starShape = {
  { 
    {0, 1, 0},
    {1, 1, 1},
    {0, 1, 0}
  }
};

void setup() {
  size(640, 400);
  frameRate(30); 
  noSmooth();
  
  // Calcul du nombre de colonnes et lignes
  cols = width/size;
  rows = height/size;

  grid = new int[cols][rows];
  nextGrid = new int[cols][rows];

  background(0); 
}

void draw() {
  // Fond transparent
  fill(0, 0, 0, 40); 
  rect(0, 0, width, height);
  stroke(30); 
  // Explosion
  if (explosion == true) {
    growCircle();
  } else {
    // Changement de couleur 
    if (colorchange < 1.0) {
      colorchange = colorchange + 0.02; 
    }
  }

  // Dessiner toutes les cellules
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      
      // Si la cellule est vivante
      if (grid[x][y] == 1) {
        
        // Calcul pour la couleur
        float d = dist(x, y, cols/2, rows/2); // Distance du centre
        float maxD = width/1.5; 
        
        // Couleurs chaudes pour explosion
        color c1 = color(
          map(d, 0, maxD, 255, 100),     // R
          map(d, 0, maxD/2, 255, 0),     // V
          map(d, 0, maxD/4, 255, 0)      // B
        );
        
        // Couleurs froides post explosion 
        color c2 = color(
          map(d, 0, maxD/1.8, 255, 0),   // R
          map(d, 0, maxD/5, 255, 0),     // V
          map(d, 0, maxD, 255, 80)       // B
        );
        
        // Melange des deux couleurs
        fill(lerpColor(c1, c2, colorchange));
        
        // Dessin du point
        ellipse(x*size + size/2, y*size + size/2, size, size);
      }
    }
  }

  // Calculer la prochaine etape
  calculateNextGen();
}

// Fonction pour faire grandir le cercle
void growCircle() {
  radius = radius + speed;
  
  // Si cercle est trop grand on stop
  if (radius > width/1.5) {
    explosion = false; 
    return;
  }
  
  // Calcul du nombre d'etoiles a ajouter
  float perimetre = 2 * PI * radius;
  int number = int(perimetre * density); 
  
  int centerX = cols / 2;
  int centerY = rows / 2;

  // Ajouter des etoiles sur le cercle
  for (int i = 0; i < number; i++) {
    float angle = random(TWO_PI);
    
    int x = int(centerX + (cos(angle) * radius) / size); 
    int y = int(centerY + (sin(angle) * radius) / size);
    
    createStar(x, y);
  }
}

// Fonction pour dessiner la forme de l'etoile dans la grille
void createStar(int x, int y) {
  // On prend la premiere forme dans le tableau
  int[][] shape = starShape[0]; 
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      int gridX = x + i - 1;
      int gridY = y + j - 1;
      
      // Vérifier qu'on est bien dans l'ecran
      if (gridX >= 0 && gridX < cols && gridY >= 0 && gridY < rows) {
        if (shape[j][i] == 1) {
           grid[gridX][gridY] = 1;
        }
      }
    }
  }
}

// Cellule automates (voir exemple de processing)
void calculateNextGen() { 
  // on sauvegard la grille actuelle
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      nextGrid[x][y] = grid[x][y];
    }
  }

  //puis on applique 
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      
      int voisins = countNeighbors(x, y); 
      
      if (nextGrid[x][y] == 1) { 
        // Meurt de solitude ou surpopulation
        if (voisins < 2 || voisins > 3) {
          grid[x][y] = 0; 
        }
      } else { 
        // Naissance
        if (voisins == 3) {
          grid[x][y] = 1; 
        }
      } 
    } 
  } 
}

// Fonction pour compter les voisins autour d'une case
int countNeighbors(int x, int y) {
  int sum = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      int col = x + i;
      int row = y + j;
      
      // Verifier les bords
      if (col >= 0 && col < cols && row >= 0 && row < rows) {
        // On ne compte pas la cellule elle-même
        if (!(i == 0 && j == 0)) {
           if (nextGrid[col][row] == 1) {
             sum++;
           }
        }
      }
    }
  }
  return sum;
}

void keyPressed() {
  // on reinitialise avec la barre espace
  if (key == ' ') {
    // on vide la grille
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        grid[x][y] = 0; 
      }
    }
    background(0); 
    
    // Variables à zéro
    radius = 0;
    explosion = true;
    colorchange = 0;
  }
}