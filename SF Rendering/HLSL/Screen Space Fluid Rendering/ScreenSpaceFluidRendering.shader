Shader "Custom/ScreenSpaceFluidRendering"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        _PointSpriteRadius("Point Sprite Radius", Float) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/shatterfantasy.sf-core/SF Rendering/HLSL/Particles/Point Sprites/PointSprites.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varying
            {
                float4 positionOS : POSITION;
                float3 PositionVS : POSITION_VS;
                float2 uv : TEXCOORD0;
            };
            
            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float  _PointSpriteRadius;
            CBUFFER_END

            Varying vert(Attributes IN)
            {
                PointSpriteOutputData pointSpriteOutData = (PointSpriteOutputData)0;
                 // Get and cache the Vertex Positions from the input so we can use it in multiple places in the pass.
                VertexPositionInputs positions = GetVertexPositionInputs(IN.positionOS.xyz);

                
                
                Varying OUT;
                OUT.positionOS = positions.positionCS;
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                OUT.PositionVS =  positions.positionVS;
                return OUT; 
            }

            half4 frag(Varying IN) : SV_Target
            {
                PointSpriteInputData pointData = (PointSpriteInputData)0;
                pointData.Color = _BaseColor;
                pointData.SphereRadius = _PointSpriteRadius;
                pointData.TexCoord = IN.uv;
                pointData.EyeSpacePos = IN.PositionVS;

                PointSpriteOutputData pointOutData = (PointSpriteOutputData)0;
                
                pointOutData = ParticleSpherePointSphere(pointData);

                
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, pointOutData.TexCoord) * _BaseColor;
                return color;
            }
            ENDHLSL
        }
    }
}
