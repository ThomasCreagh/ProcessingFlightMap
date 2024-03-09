// Basic Math

float clamp(float val, float minVal, float maxVal) {
  return max(min(val, maxVal), minVal);
}

boolean approx(float val, float checkAgainst){
  return abs(val - checkAgainst) < 0.0001f;
}

// PVector Math

PVector slerp(PVector a, PVector b, float t) {
  a = a.copy().normalize();
  b = b.copy().normalize();

  float dot = clamp(a.copy().dot(b), -1.0f, 1.0f);
  if (approx(dot, -1)) {
    return rotateY(a, PI * t);
  }

  float omega = acos(dot);  
  if (approx(omega, 0))
    return PVector.lerp(a, b, t);

  return a.mult(sin((1-t) * omega) / sin(omega)).add(b.mult(sin(t * omega) / sin(omega))).normalize();
}

PVector rotateY(PVector v, float angle) {
  float x = v.x * cos(angle) - v.z * sin(angle);
  float z = v.x * sin(angle) + v.z * cos(angle);
  return new PVector(x, v.y, z);
}

// Descending code authorship changes:
// F. Wright, Created C_Math tab, clamp(), slerp(), approx() and rotateY() for global use, 3pm 08/03/24