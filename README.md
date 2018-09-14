# Unity3D-PGMToonShader
Free ToonShader for Unity3D.

# About the LUT parameter
You'll need a LookUp texture in order for the shader to work properly. The texture must be a grayscale image. This texture will be used for mapping the light gradient into a custom (and discretized) one.

# CAUTION: LUT import configuration
Ensure that you import the texture as Non-linear (disable de sRGB checkbox), uncheck mipmap generation, set as Compress None and set repetition to CLAMP mode. You could get strange artifacts otherwise...
