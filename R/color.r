NULL

LAB_to_polarLAB <- function(lab) {
    L <- lab[,1]
    A <- lab[,2]
    B <- lab[,3]
    cbind(L = L, C = sqrt(A * A + B * B), H = (atan2(B, A) * (180/pi)) %% 360)
}

polarLAB_to_LAB <- function(lch) {
    L <- lch[,1]
    C <- lch[,2]
    H <- lch[,3]
    cbind(L = L, A = cos(H * (pi/180)) * C, B = sin(H* (pi/180)) * C)
}