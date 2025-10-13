def exteuc(a, b) # return the solution [x, y] of ax + by = gcd(a, b)
  return [1, 0] if b == 0
  y, x = exteuc(b, a % b)
  [x, y - a / b * x]
end
