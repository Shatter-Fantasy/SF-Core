
/* Data struct to be used with screen space rendering that implement any form of Point Sprites.
 * See Screen Space Rendering Fluids for an example.
 * https://developer.download.nvidia.com/presentations/2010/gdc/Direct3D_Effects.pdf
 */
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

struct PointSpriteInputData
{
    float2 TexCoord;
    float3 EyeSpacePos;
    float3 Color;
    float SphereRadius;
};

struct PointSpriteOutputData
{
    float2 TexCoord : TEXCOORD0;
    float4 FragDepth : TEXCOORD1;
    float4 FragColor : TEXCOORD3;
};


PointSpriteOutputData ParticleSpherePointSphere(PointSpriteInputData inputData)
{
    PointSpriteOutputData OUT = (PointSpriteOutputData)0;

    // Calculate the eye space normal from texture coordinates.
    float3 eyeNormal;
    // Center the texture coordinate.
    eyeNormal.xy = inputData.TexCoord * 2.0 - 1.0;
    float r2 = dot(eyeNormal.xy,eyeNormal.xy);

    // If the calculated normal is outside of the Testing sphere discard.
    if (r2 > 1.0) discard;
    
    eyeNormal.z = -sqrt(1.0 - r2);

    // Calculate the depth
    float4 pixelPos = float4 (inputData.EyeSpacePos + (eyeNormal * inputData.SphereRadius), 1);
    float4 clipSpacePos = mul(pixelPos, unity_CameraProjection);// This might need to be UNITY_MATRIX_P
    OUT.FragDepth =  clipSpacePos.z / clipSpacePos.w;

    // Get the directional light and calculate the color with lighting applied.
    Light light = GetMainLight();
    float diffuse = max(0.0, dot(eyeNormal,light.direction));
    OUT.FragColor = (diffuse * inputData.Color,1);
    return OUT;
}

float3 PointSpriteNormal()
{
    // Read eye-space depth texture
    // Calculate the position of eye from the depth

    // Directives for the difference

    // Calculate the normals
}