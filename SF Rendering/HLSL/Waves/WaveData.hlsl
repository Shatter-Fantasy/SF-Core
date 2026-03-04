#ifndef SF_Waves
#define SF_Waves

#include "Packages/shatterfantasy.sf-core/SF Rendering/HLSL/Math Utilities/MathUtilities.hlsl"

// Macros
#define WaveNumber(waveLength) (SF_TAU / waveLength)
#define WaveNumberReciprocal(waveNumber)(waveNumber / SF_TAU)

// Wave Speed
#define PhaseSpeed(wavelength) ((sqrt(SF_GRAVITY * wavelength) / SF_TAU))
/*

    (x,y) = (a,b) =  (a,b) is called Lagrangian coordinates = the coordinates system used for fluid dynamics.
    Fun side note: Lagrangian coordinates can be used to make flow fields.
    a = origin position on x-axis.
    b = origin position on y-axis.

    bs below is a non-positive constant for the free surface line at certain y positions of the wave.
    
    Original formula before simplifying for computer calculations
    Note this is for getting the x and y positions. For 3D coordinates there is a dot product involved.
    This formula is just shown to help make it easier to understand the 3D formula.

    f(X) = a + (exp(kb) / k ) * sin(k(a + ct))  
    f(Y) = b + (exp(kb) / k ) * sin(k(b + ct))

    Choices to simplify it:
    
    Choice one replace exp(kb) / k with c for phase speed.
    f(X) = a + sqrt(g/k) * sin(k(a + ct))  
    f(Y) = b + sqrt(g/k) * sin(k(b + ct))

    Choice two:
    Use this if you want to pass in the desired phase speed/wave speed
    via setting it from script/material inspector

    f(X) = a + c * sin(k(a + ct))  
    f(Y) = b + c * sin(k(b + ct))
    Wave Crests: The highest point of a wave
    Rotational trochoidal waves highest crest angle is 0, which is what is generally used for calculations.
    Stoke Wave has a crest angle of 120

    Wave Trough: The lowest point of a wave.
    Wave Height: The distance from the trough to the crest.

    Example drawing a straight line through the center of a wave is just b.
    Wave Height = H = 2/k * exp(kbs)

    Wave Period (Time) = T = wavelength (lambda symbol) / phase speed
   
*/

struct WaveVertexData
{
    half3 positionWS; // Vertex calculated in world space.
    half3 normalWS; // Normal for vertexes in world space.
    /* Tangents for the vertexes in world space with the w value being used for b-normals when needed.
     * They are used the bump maps to add detail the waves.
     */
    half4 tangentWS;
};

struct WaveData
{
    half WaveLength; // The lambda in math formulas.
    half Amplitude; // The distance to the crest from the center aka height of the wave from the center.
    half PhaseSpeed; // The c in most formulas.
    half2 OriginPosition; // The starting posiiton of a wave to be calculated for. // Don't need the z here. It has to be calculated in the methods.
};


WaveVertexData DefaultWaveVertexData()
{
    WaveVertexData data = (WaveVertexData)0;

    // Set the normals to point upwards.
    data.normalWS = half3(0.f,1.f,0.f);
    // This is setting the tangents to be pointed the right for the normal U Texture coordinates.
    // The fourth value is used to calculate for binormals.  It has to be 1 or -1. Nothing else.
    data.tangentWS = half4(1.f,0.f,0.f,1.f);

    return data;
}
#endif
