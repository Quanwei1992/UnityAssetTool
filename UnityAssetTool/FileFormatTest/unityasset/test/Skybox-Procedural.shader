Shader "Skybox/Procedural" {
Properties {
[KeywordEnum(None, Simple, High Quality)]  _SunDisk ("Sun", Float) = 2
 _SunSize ("Sun Size", Range(0,1)) = 0.04
 _AtmosphereThickness ("Atmoshpere Thickness", Range(0,5)) = 1
 _SkyTint ("Sky Tint", Color) = (0.5,0.5,0.5,1)
 _GroundColor ("Ground", Color) = (0.369,0.349,0.341,1)
 _Exposure ("Exposure", Range(0,8)) = 1.3
}
SubShader { 
 Tags { "QUEUE"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
 Pass {
  Tags { "QUEUE"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
  ZWrite Off
  Cull Off
  GpuProgramID 1581
Program "vp" {
SubProgram "gles " {
Keywords { "_SUNDISK_NONE" }
"!!GLES
#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform lowp vec4 unity_ColorSpaceDouble;
uniform mediump float _Exposure;
uniform mediump vec3 _GroundColor;
uniform mediump vec3 _SkyTint;
uniform mediump float _AtmosphereThickness;
varying mediump float xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 cOut_1;
  mediump vec3 cIn_2;
  highp float far_3;
  highp float kKr4PI_4;
  highp float kKrESun_5;
  highp vec3 kSkyTintInGammaSpace_6;
  highp vec4 tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_7 = (glstate_matrix_mvp * _glesVertex);
  mediump vec3 tmpvar_9;
  if ((unity_ColorSpaceDouble.x > 2.0)) {
    tmpvar_9 = pow (_SkyTint, vec3(0.4545454, 0.4545454, 0.4545454));
  } else {
    tmpvar_9 = _SkyTint;
  };
  kSkyTintInGammaSpace_6 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (1.0/(pow (mix (vec3(0.5, 0.42, 0.325), vec3(0.8, 0.72, 0.625), 
    (vec3(1.0, 1.0, 1.0) - kSkyTintInGammaSpace_6)
  ), vec3(4.0, 4.0, 4.0))));
  mediump float tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = pow (_AtmosphereThickness, 2.5);
  tmpvar_11 = (0.05 * tmpvar_12);
  kKrESun_5 = tmpvar_11;
  mediump float tmpvar_13;
  tmpvar_13 = (0.03141593 * tmpvar_12);
  kKr4PI_4 = tmpvar_13;
  highp mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_14 * _glesVertex.xyz));
  far_3 = 0.0;
  if ((tmpvar_15.y >= 0.0)) {
    highp vec3 frontColor_16;
    highp vec3 samplePoint_17;
    far_3 = (sqrt((
      (1.050625 + (tmpvar_15.y * tmpvar_15.y))
     - 1.0)) - tmpvar_15.y);
    highp float tmpvar_18;
    tmpvar_18 = (1.0 - (dot (tmpvar_15, vec3(0.0, 1.0001, 0.0)) / 1.0001));
    highp float tmpvar_19;
    tmpvar_19 = (exp((-0.00287 + 
      (tmpvar_18 * (0.459 + (tmpvar_18 * (3.83 + 
        (tmpvar_18 * (-6.8 + (tmpvar_18 * 5.25)))
      ))))
    )) * 0.2460318);
    highp float tmpvar_20;
    tmpvar_20 = (far_3 / 2.0);
    highp float tmpvar_21;
    tmpvar_21 = (tmpvar_20 * 40.00004);
    highp vec3 tmpvar_22;
    tmpvar_22 = (tmpvar_15 * tmpvar_20);
    highp vec3 tmpvar_23;
    tmpvar_23 = (vec3(0.0, 1.0001, 0.0) + (tmpvar_22 * 0.5));
    highp float tmpvar_24;
    tmpvar_24 = sqrt(dot (tmpvar_23, tmpvar_23));
    highp float tmpvar_25;
    tmpvar_25 = exp((160.0002 * (1.0 - tmpvar_24)));
    highp float tmpvar_26;
    tmpvar_26 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, tmpvar_23) / tmpvar_24));
    highp float tmpvar_27;
    tmpvar_27 = (1.0 - (dot (tmpvar_15, tmpvar_23) / tmpvar_24));
    frontColor_16 = (exp((
      -(clamp ((tmpvar_19 + (tmpvar_25 * 
        ((0.25 * exp((-0.00287 + 
          (tmpvar_26 * (0.459 + (tmpvar_26 * (3.83 + 
            (tmpvar_26 * (-6.8 + (tmpvar_26 * 5.25)))
          ))))
        ))) - (0.25 * exp((-0.00287 + 
          (tmpvar_27 * (0.459 + (tmpvar_27 * (3.83 + 
            (tmpvar_27 * (-6.8 + (tmpvar_27 * 5.25)))
          ))))
        ))))
      )), 0.0, 50.0))
     * 
      ((tmpvar_10 * kKr4PI_4) + 0.01256637)
    )) * (tmpvar_25 * tmpvar_21));
    samplePoint_17 = (tmpvar_23 + tmpvar_22);
    highp float tmpvar_28;
    tmpvar_28 = sqrt(dot (samplePoint_17, samplePoint_17));
    highp float tmpvar_29;
    tmpvar_29 = exp((160.0002 * (1.0 - tmpvar_28)));
    highp float tmpvar_30;
    tmpvar_30 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, samplePoint_17) / tmpvar_28));
    highp float tmpvar_31;
    tmpvar_31 = (1.0 - (dot (tmpvar_15, samplePoint_17) / tmpvar_28));
    frontColor_16 = (frontColor_16 + (exp(
      (-(clamp ((tmpvar_19 + 
        (tmpvar_29 * ((0.25 * exp(
          (-0.00287 + (tmpvar_30 * (0.459 + (tmpvar_30 * 
            (3.83 + (tmpvar_30 * (-6.8 + (tmpvar_30 * 5.25))))
          ))))
        )) - (0.25 * exp(
          (-0.00287 + (tmpvar_31 * (0.459 + (tmpvar_31 * 
            (3.83 + (tmpvar_31 * (-6.8 + (tmpvar_31 * 5.25))))
          ))))
        ))))
      ), 0.0, 50.0)) * ((tmpvar_10 * kKr4PI_4) + 0.01256637))
    ) * (tmpvar_29 * tmpvar_21)));
    samplePoint_17 = (samplePoint_17 + tmpvar_22);
    cIn_2 = (frontColor_16 * (tmpvar_10 * kKrESun_5));
    cOut_1 = (frontColor_16 * 0.02);
  } else {
    highp vec3 frontColor_1_32;
    far_3 = (-0.0001 / min (-0.001, tmpvar_15.y));
    highp vec3 tmpvar_33;
    tmpvar_33 = (vec3(0.0, 1.0001, 0.0) + (far_3 * tmpvar_15));
    highp float tmpvar_34;
    highp float tmpvar_35;
    tmpvar_35 = (1.0 - dot (-(tmpvar_15), tmpvar_33));
    tmpvar_34 = (0.25 * exp((-0.00287 + 
      (tmpvar_35 * (0.459 + (tmpvar_35 * (3.83 + 
        (tmpvar_35 * (-6.8 + (tmpvar_35 * 5.25)))
      ))))
    )));
    highp float tmpvar_36;
    tmpvar_36 = (1.0 - dot (_WorldSpaceLightPos0.xyz, tmpvar_33));
    highp float tmpvar_37;
    tmpvar_37 = (far_3 / 2.0);
    highp vec3 tmpvar_38;
    tmpvar_38 = (vec3(0.0, 1.0001, 0.0) + ((tmpvar_15 * tmpvar_37) * 0.5));
    highp float tmpvar_39;
    tmpvar_39 = exp((160.0002 * (1.0 - 
      sqrt(dot (tmpvar_38, tmpvar_38))
    )));
    highp vec3 tmpvar_40;
    tmpvar_40 = exp((-(
      clamp (((tmpvar_39 * (
        (0.25 * exp((-0.00287 + (tmpvar_36 * 
          (0.459 + (tmpvar_36 * (3.83 + (tmpvar_36 * 
            (-6.8 + (tmpvar_36 * 5.25))
          ))))
        ))))
       + tmpvar_34)) - (0.9996001 * tmpvar_34)), 0.0, 50.0)
    ) * (
      (tmpvar_10 * kKr4PI_4)
     + 0.01256637)));
    frontColor_1_32 = (tmpvar_40 * (tmpvar_39 * (tmpvar_37 * 40.00004)));
    cIn_2 = (frontColor_1_32 * ((tmpvar_10 * kKrESun_5) + 0.02));
    highp vec3 tmpvar_41;
    tmpvar_41 = clamp (tmpvar_40, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    cOut_1 = tmpvar_41;
  };
  tmpvar_8 = (-(tmpvar_15.y) / 0.02);
  mediump vec3 light_42;
  light_42 = _WorldSpaceLightPos0.xyz;
  mediump vec3 ray_43;
  ray_43 = -(tmpvar_15);
  mediump float tmpvar_44;
  tmpvar_44 = dot (light_42, ray_43);
  gl_Position = tmpvar_7;
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = (_Exposure * (cIn_2 + (_GroundColor * cOut_1)));
  xlv_TEXCOORD2 = (_Exposure * (cIn_2 * (0.75 + 
    (0.75 * (tmpvar_44 * tmpvar_44))
  )));
}


#endif
#ifdef FRAGMENT
varying mediump float xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = mix (xlv_TEXCOORD2, xlv_TEXCOORD1, vec3(clamp (xlv_TEXCOORD0, 0.0, 1.0)));
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "_SUNDISK_NONE" }
"!!GLES3
#ifdef VERTEX
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in highp vec4 in_POSITION0;
out mediump float vs_TEXCOORD0;
out mediump vec3 vs_TEXCOORD1;
out mediump vec3 vs_TEXCOORD2;
highp vec4 t0;
bool tb0;
mediump vec3 t16_1;
highp vec4 t2;
highp vec4 t3;
mediump vec3 t16_3;
bool tb3;
highp vec3 t4;
mediump vec3 t16_4;
highp vec4 t5;
highp vec3 t6;
highp float t9;
highp float t11;
highp vec3 t12;
highp float t17;
highp float t18;
highp float t19;
highp float t21;
highp float t24;
highp float t25;
void main()
{
    t0 = in_POSITION0.yyyy * glstate_matrix_mvp[1];
    t0 = glstate_matrix_mvp[0] * in_POSITION0.xxxx + t0;
    t0 = glstate_matrix_mvp[2] * in_POSITION0.zzzz + t0;
    gl_Position = glstate_matrix_mvp[3] * in_POSITION0.wwww + t0;
    tb0 = 2.0<unity_ColorSpaceDouble.x;
    t16_1.xyz = log2(vec3(_SkyTint.x, _SkyTint.y, _SkyTint.z));
    t16_1.xyz = t16_1.xyz * vec3(0.454545468, 0.454545468, 0.454545468);
    t16_1.xyz = exp2(t16_1.xyz);
    t16_1.xyz = (bool(tb0)) ? t16_1.xyz : vec3(_SkyTint.x, _SkyTint.y, _SkyTint.z);
    t0.xyz = (-t16_1.xyz) + vec3(1.0, 1.0, 1.0);
    t0.xyz = t0.xyz * vec3(0.300000012, 0.300000042, 0.300000012) + vec3(0.5, 0.419999987, 0.324999988);
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = vec3(1.0, 1.0, 1.0) / t0.xyz;
    t16_1.x = log2(_AtmosphereThickness);
    t16_1.x = t16_1.x * 2.5;
    t16_1.x = exp2(t16_1.x);
    t16_1.xy = t16_1.xx * vec2(0.049999997, 0.0314159282);
    t2.xyz = in_POSITION0.yyy * _Object2World[1].xyz;
    t2.xyz = _Object2World[0].xyz * in_POSITION0.xxx + t2.xyz;
    t2.xyz = _Object2World[2].xyz * in_POSITION0.zzz + t2.xyz;
    t21 = dot(t2.xyz, t2.xyz);
    t21 = inversesqrt(t21);
    t2.xzw = vec3(t21) * t2.xyz;
    tb3 = t2.z>=0.0;
    if(tb3){
        t3.x = t2.z * t2.z + 0.0506249666;
        t3.x = sqrt(t3.x);
        t3.x = (-t2.y) * t21 + t3.x;
        t21 = (-t2.y) * t21 + 1.0;
        t9 = t21 * 5.25 + -6.80000019;
        t9 = t21 * t9 + 3.82999992;
        t9 = t21 * t9 + 0.458999991;
        t21 = t21 * t9 + -0.00286999997;
        t21 = t21 * 1.44269502;
        t21 = exp2(t21);
        t21 = t21 * 0.246031836;
        t3.xy = t3.xx * vec2(0.5, 20.0);
        t4.xyz = t2.xzw * t3.xxx;
        t4.xyz = t4.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t9 = dot(t4.xyz, t4.xyz);
        t9 = sqrt(t9);
        t17 = (-t9) + 1.0;
        t17 = t17 * 230.831207;
        t17 = exp2(t17);
        t24 = dot(_WorldSpaceLightPos0.xyz, t4.xyz);
        t24 = t24 / t9;
        t25 = dot(t2.xzw, t4.xyz);
        t9 = t25 / t9;
        t24 = (-t24) + 1.0;
        t25 = t24 * 5.25 + -6.80000019;
        t25 = t24 * t25 + 3.82999992;
        t25 = t24 * t25 + 0.458999991;
        t24 = t24 * t25 + -0.00286999997;
        t24 = t24 * 1.44269502;
        t24 = exp2(t24);
        t9 = (-t9) + 1.0;
        t25 = t9 * 5.25 + -6.80000019;
        t25 = t9 * t25 + 3.82999992;
        t25 = t9 * t25 + 0.458999991;
        t9 = t9 * t25 + -0.00286999997;
        t9 = t9 * 1.44269502;
        t9 = exp2(t9);
        t9 = t9 * 0.25;
        t9 = t24 * 0.25 + (-t9);
        t9 = t17 * t9 + t21;
        t9 = max(t9, 0.0);
        t9 = min(t9, 50.0);
        t5.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t6.xyz = (-vec3(t9)) * t5.xyz;
        t6.xyz = t6.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t6.xyz = exp2(t6.xyz);
        t9 = t3.y * t17;
        t3.xzw = t2.xzw * t3.xxx + t4.xyz;
        t4.x = dot(t3.xzw, t3.xzw);
        t4.x = sqrt(t4.x);
        t11 = (-t4.x) + 1.0;
        t11 = t11 * 230.831207;
        t11 = exp2(t11);
        t18 = dot(_WorldSpaceLightPos0.xyz, t3.xzw);
        t18 = t18 / t4.x;
        t3.x = dot(t2.xzw, t3.xzw);
        t3.x = t3.x / t4.x;
        t17 = (-t18) + 1.0;
        t24 = t17 * 5.25 + -6.80000019;
        t24 = t17 * t24 + 3.82999992;
        t24 = t17 * t24 + 0.458999991;
        t17 = t17 * t24 + -0.00286999997;
        t17 = t17 * 1.44269502;
        t17 = exp2(t17);
        t3.x = (-t3.x) + 1.0;
        t24 = t3.x * 5.25 + -6.80000019;
        t24 = t3.x * t24 + 3.82999992;
        t24 = t3.x * t24 + 0.458999991;
        t3.x = t3.x * t24 + -0.00286999997;
        t3.x = t3.x * 1.44269502;
        t3.x = exp2(t3.x);
        t3.x = t3.x * 0.25;
        t3.x = t17 * 0.25 + (-t3.x);
        t21 = t11 * t3.x + t21;
        t21 = max(t21, 0.0);
        t21 = min(t21, 50.0);
        t3.xzw = t5.xyz * (-vec3(t21));
        t3.xzw = t3.xzw * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xzw = exp2(t3.xzw);
        t21 = t3.y * t11;
        t3.xyz = vec3(t21) * t3.xzw;
        t3.xyz = t6.xyz * vec3(t9) + t3.xyz;
        t4.xyz = t0.xyz * t16_1.xxx;
        t4.xyz = t3.xyz * t4.xyz;
        t3.xyz = t3.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    } else {
        t21 = min(t2.z, -0.00100000005);
        t21 = -9.99999975e-005 / t21;
        t5.xyz = vec3(t21) * t2.xzw + vec3(0.0, 1.00010002, 0.0);
        t5.w = dot((-t2.xzw), t5.xyz);
        t5.x = dot(_WorldSpaceLightPos0.xyz, t5.xyz);
        t5.xy = (-t5.xw) + vec2(1.0, 1.0);
        t19 = t5.y * 5.25 + -6.80000019;
        t19 = t5.y * t19 + 3.82999992;
        t19 = t5.y * t19 + 0.458999991;
        t12.x = t5.y * t19 + -0.00286999997;
        t12.x = t12.x * 1.44269502;
        t5.y = exp2(t12.x);
        t19 = t5.x * 5.25 + -6.80000019;
        t19 = t5.x * t19 + 3.82999992;
        t19 = t5.x * t19 + 0.458999991;
        t5.x = t5.x * t19 + -0.00286999997;
        t5.xyz = t5.xyy * vec3(1.44269502, 0.25, 0.249900013);
        t5.x = exp2(t5.x);
        t5.x = t5.x * 0.25 + t5.y;
        t12.xz = vec2(t21) * vec2(0.5, 20.0);
        t6.xyz = t2.xzw * t12.xxx;
        t6.xyz = t6.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t21 = dot(t6.xyz, t6.xyz);
        t21 = sqrt(t21);
        t21 = (-t21) + 1.0;
        t21 = t21 * 230.831207;
        t21 = exp2(t21);
        t5.x = t21 * t5.x + (-t5.z);
        t5.x = max(t5.x, 0.0);
        t5.x = min(t5.x, 50.0);
        t6.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t5.xyz = (-t5.xxx) * t6.xyz;
        t5.xyz = t5.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xyz = exp2(t5.xyz);
        t21 = t12.z * t21;
        t5.xyz = vec3(t21) * t3.xyz;
        t0.xyz = t0.xyz * t16_1.xxx + vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t4.xyz = t0.xyz * t5.xyz;
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    //ENDIF
    }
    t0.x = t2.z * -50.0;
    t16_1.xyz = vec3(_GroundColor.x, _GroundColor.y, _GroundColor.z) * t16_3.xyz + t16_4.xyz;
    vs_TEXCOORD1.xyz = t16_1.xyz * vec3(_Exposure);
    t16_1.x = dot(_WorldSpaceLightPos0.xyz, (-t2.xzw));
    t16_1.x = t16_1.x * t16_1.x;
    t16_1.x = t16_1.x * 0.75 + 0.75;
    t16_1.xyz = t16_1.xxx * t16_4.xyz;
    vs_TEXCOORD2.xyz = t16_1.xyz * vec3(_Exposure);
    vs_TEXCOORD0 = t0.x;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es
precision highp float;
precision highp int;
in mediump float vs_TEXCOORD0;
in mediump vec3 vs_TEXCOORD1;
in mediump vec3 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
mediump float t16_0;
mediump vec3 t16_1;
void main()
{
    t16_0 = vs_TEXCOORD0;
    t16_0 = clamp(t16_0, 0.0, 1.0);
    t16_1.xyz = vec3(vs_TEXCOORD1.x + (-vs_TEXCOORD2.x), vs_TEXCOORD1.y + (-vs_TEXCOORD2.y), vs_TEXCOORD1.z + (-vs_TEXCOORD2.z));
    SV_Target0.xyz = vec3(t16_0) * t16_1.xyz + vs_TEXCOORD2.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "_SUNDISK_SIMPLE" }
"!!GLES
#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform lowp vec4 unity_ColorSpaceDouble;
uniform lowp vec4 _LightColor0;
uniform mediump float _Exposure;
uniform mediump vec3 _GroundColor;
uniform mediump vec3 _SkyTint;
uniform mediump float _AtmosphereThickness;
varying mediump vec3 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 cOut_1;
  mediump vec3 cIn_2;
  highp float far_3;
  highp float kKr4PI_4;
  highp float kKrESun_5;
  highp vec3 kSkyTintInGammaSpace_6;
  highp vec4 tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_7 = (glstate_matrix_mvp * _glesVertex);
  mediump vec3 tmpvar_9;
  if ((unity_ColorSpaceDouble.x > 2.0)) {
    tmpvar_9 = pow (_SkyTint, vec3(0.4545454, 0.4545454, 0.4545454));
  } else {
    tmpvar_9 = _SkyTint;
  };
  kSkyTintInGammaSpace_6 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (1.0/(pow (mix (vec3(0.5, 0.42, 0.325), vec3(0.8, 0.72, 0.625), 
    (vec3(1.0, 1.0, 1.0) - kSkyTintInGammaSpace_6)
  ), vec3(4.0, 4.0, 4.0))));
  mediump float tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = pow (_AtmosphereThickness, 2.5);
  tmpvar_11 = (0.05 * tmpvar_12);
  kKrESun_5 = tmpvar_11;
  mediump float tmpvar_13;
  tmpvar_13 = (0.03141593 * tmpvar_12);
  kKr4PI_4 = tmpvar_13;
  highp mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_14 * _glesVertex.xyz));
  far_3 = 0.0;
  if ((tmpvar_15.y >= 0.0)) {
    highp vec3 frontColor_16;
    highp vec3 samplePoint_17;
    far_3 = (sqrt((
      (1.050625 + (tmpvar_15.y * tmpvar_15.y))
     - 1.0)) - tmpvar_15.y);
    highp float tmpvar_18;
    tmpvar_18 = (1.0 - (dot (tmpvar_15, vec3(0.0, 1.0001, 0.0)) / 1.0001));
    highp float tmpvar_19;
    tmpvar_19 = (exp((-0.00287 + 
      (tmpvar_18 * (0.459 + (tmpvar_18 * (3.83 + 
        (tmpvar_18 * (-6.8 + (tmpvar_18 * 5.25)))
      ))))
    )) * 0.2460318);
    highp float tmpvar_20;
    tmpvar_20 = (far_3 / 2.0);
    highp float tmpvar_21;
    tmpvar_21 = (tmpvar_20 * 40.00004);
    highp vec3 tmpvar_22;
    tmpvar_22 = (tmpvar_15 * tmpvar_20);
    highp vec3 tmpvar_23;
    tmpvar_23 = (vec3(0.0, 1.0001, 0.0) + (tmpvar_22 * 0.5));
    highp float tmpvar_24;
    tmpvar_24 = sqrt(dot (tmpvar_23, tmpvar_23));
    highp float tmpvar_25;
    tmpvar_25 = exp((160.0002 * (1.0 - tmpvar_24)));
    highp float tmpvar_26;
    tmpvar_26 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, tmpvar_23) / tmpvar_24));
    highp float tmpvar_27;
    tmpvar_27 = (1.0 - (dot (tmpvar_15, tmpvar_23) / tmpvar_24));
    frontColor_16 = (exp((
      -(clamp ((tmpvar_19 + (tmpvar_25 * 
        ((0.25 * exp((-0.00287 + 
          (tmpvar_26 * (0.459 + (tmpvar_26 * (3.83 + 
            (tmpvar_26 * (-6.8 + (tmpvar_26 * 5.25)))
          ))))
        ))) - (0.25 * exp((-0.00287 + 
          (tmpvar_27 * (0.459 + (tmpvar_27 * (3.83 + 
            (tmpvar_27 * (-6.8 + (tmpvar_27 * 5.25)))
          ))))
        ))))
      )), 0.0, 50.0))
     * 
      ((tmpvar_10 * kKr4PI_4) + 0.01256637)
    )) * (tmpvar_25 * tmpvar_21));
    samplePoint_17 = (tmpvar_23 + tmpvar_22);
    highp float tmpvar_28;
    tmpvar_28 = sqrt(dot (samplePoint_17, samplePoint_17));
    highp float tmpvar_29;
    tmpvar_29 = exp((160.0002 * (1.0 - tmpvar_28)));
    highp float tmpvar_30;
    tmpvar_30 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, samplePoint_17) / tmpvar_28));
    highp float tmpvar_31;
    tmpvar_31 = (1.0 - (dot (tmpvar_15, samplePoint_17) / tmpvar_28));
    frontColor_16 = (frontColor_16 + (exp(
      (-(clamp ((tmpvar_19 + 
        (tmpvar_29 * ((0.25 * exp(
          (-0.00287 + (tmpvar_30 * (0.459 + (tmpvar_30 * 
            (3.83 + (tmpvar_30 * (-6.8 + (tmpvar_30 * 5.25))))
          ))))
        )) - (0.25 * exp(
          (-0.00287 + (tmpvar_31 * (0.459 + (tmpvar_31 * 
            (3.83 + (tmpvar_31 * (-6.8 + (tmpvar_31 * 5.25))))
          ))))
        ))))
      ), 0.0, 50.0)) * ((tmpvar_10 * kKr4PI_4) + 0.01256637))
    ) * (tmpvar_29 * tmpvar_21)));
    samplePoint_17 = (samplePoint_17 + tmpvar_22);
    cIn_2 = (frontColor_16 * (tmpvar_10 * kKrESun_5));
    cOut_1 = (frontColor_16 * 0.02);
  } else {
    highp vec3 frontColor_1_32;
    far_3 = (-0.0001 / min (-0.001, tmpvar_15.y));
    highp vec3 tmpvar_33;
    tmpvar_33 = (vec3(0.0, 1.0001, 0.0) + (far_3 * tmpvar_15));
    highp float tmpvar_34;
    highp float tmpvar_35;
    tmpvar_35 = (1.0 - dot (-(tmpvar_15), tmpvar_33));
    tmpvar_34 = (0.25 * exp((-0.00287 + 
      (tmpvar_35 * (0.459 + (tmpvar_35 * (3.83 + 
        (tmpvar_35 * (-6.8 + (tmpvar_35 * 5.25)))
      ))))
    )));
    highp float tmpvar_36;
    tmpvar_36 = (1.0 - dot (_WorldSpaceLightPos0.xyz, tmpvar_33));
    highp float tmpvar_37;
    tmpvar_37 = (far_3 / 2.0);
    highp vec3 tmpvar_38;
    tmpvar_38 = (vec3(0.0, 1.0001, 0.0) + ((tmpvar_15 * tmpvar_37) * 0.5));
    highp float tmpvar_39;
    tmpvar_39 = exp((160.0002 * (1.0 - 
      sqrt(dot (tmpvar_38, tmpvar_38))
    )));
    highp vec3 tmpvar_40;
    tmpvar_40 = exp((-(
      clamp (((tmpvar_39 * (
        (0.25 * exp((-0.00287 + (tmpvar_36 * 
          (0.459 + (tmpvar_36 * (3.83 + (tmpvar_36 * 
            (-6.8 + (tmpvar_36 * 5.25))
          ))))
        ))))
       + tmpvar_34)) - (0.9996001 * tmpvar_34)), 0.0, 50.0)
    ) * (
      (tmpvar_10 * kKr4PI_4)
     + 0.01256637)));
    frontColor_1_32 = (tmpvar_40 * (tmpvar_39 * (tmpvar_37 * 40.00004)));
    cIn_2 = (frontColor_1_32 * ((tmpvar_10 * kKrESun_5) + 0.02));
    highp vec3 tmpvar_41;
    tmpvar_41 = clamp (tmpvar_40, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    cOut_1 = tmpvar_41;
  };
  tmpvar_8 = -(tmpvar_15);
  mediump vec3 light_42;
  light_42 = _WorldSpaceLightPos0.xyz;
  mediump vec3 ray_43;
  ray_43 = -(tmpvar_15);
  mediump float tmpvar_44;
  tmpvar_44 = dot (light_42, ray_43);
  gl_Position = tmpvar_7;
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = (_Exposure * (cIn_2 + (_GroundColor * cOut_1)));
  xlv_TEXCOORD2 = (_Exposure * (cIn_2 * (0.75 + 
    (0.75 * (tmpvar_44 * tmpvar_44))
  )));
  xlv_TEXCOORD3 = (_Exposure * (cOut_1 * _LightColor0.xyz));
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _WorldSpaceLightPos0;
uniform mediump float _SunSize;
varying mediump vec3 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 col_1;
  mediump float tmpvar_2;
  tmpvar_2 = (xlv_TEXCOORD0.y / 0.02);
  mediump vec3 tmpvar_3;
  tmpvar_3 = mix (xlv_TEXCOORD2, xlv_TEXCOORD1, vec3(clamp (tmpvar_2, 0.0, 1.0)));
  col_1 = tmpvar_3;
  if ((tmpvar_2 < 0.0)) {
    mediump vec3 vec1_4;
    vec1_4 = _WorldSpaceLightPos0.xyz;
    mediump vec3 tmpvar_5;
    tmpvar_5 = (vec1_4 - -(xlv_TEXCOORD0));
    mediump float tmpvar_6;
    tmpvar_6 = clamp ((sqrt(
      dot (tmpvar_5, tmpvar_5)
    ) / _SunSize), 0.0, 1.0);
    mediump float tmpvar_7;
    tmpvar_7 = (1.0 - (tmpvar_6 * (tmpvar_6 * 
      (3.0 - (2.0 * tmpvar_6))
    )));
    col_1 = (tmpvar_3 + ((
      (8000.0 * tmpvar_7)
     * tmpvar_7) * xlv_TEXCOORD3));
  };
  mediump vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = col_1;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "_SUNDISK_SIMPLE" }
"!!GLES3
#ifdef VERTEX
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in highp vec4 in_POSITION0;
out mediump vec3 vs_TEXCOORD0;
out mediump vec3 vs_TEXCOORD1;
out mediump vec3 vs_TEXCOORD2;
out mediump vec3 vs_TEXCOORD3;
highp vec4 t0;
bool tb0;
mediump vec3 t16_1;
highp vec4 t2;
highp vec4 t3;
mediump vec3 t16_3;
bool tb3;
highp vec3 t4;
mediump vec3 t16_4;
highp vec4 t5;
highp vec3 t6;
highp float t9;
highp float t11;
highp vec3 t12;
highp float t17;
highp float t18;
highp float t19;
highp float t21;
highp float t24;
highp float t25;
void main()
{
    t0 = in_POSITION0.yyyy * glstate_matrix_mvp[1];
    t0 = glstate_matrix_mvp[0] * in_POSITION0.xxxx + t0;
    t0 = glstate_matrix_mvp[2] * in_POSITION0.zzzz + t0;
    gl_Position = glstate_matrix_mvp[3] * in_POSITION0.wwww + t0;
    tb0 = 2.0<unity_ColorSpaceDouble.x;
    t16_1.xyz = log2(vec3(_SkyTint.x, _SkyTint.y, _SkyTint.z));
    t16_1.xyz = t16_1.xyz * vec3(0.454545468, 0.454545468, 0.454545468);
    t16_1.xyz = exp2(t16_1.xyz);
    t16_1.xyz = (bool(tb0)) ? t16_1.xyz : vec3(_SkyTint.x, _SkyTint.y, _SkyTint.z);
    t0.xyz = (-t16_1.xyz) + vec3(1.0, 1.0, 1.0);
    t0.xyz = t0.xyz * vec3(0.300000012, 0.300000042, 0.300000012) + vec3(0.5, 0.419999987, 0.324999988);
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = vec3(1.0, 1.0, 1.0) / t0.xyz;
    t16_1.x = log2(_AtmosphereThickness);
    t16_1.x = t16_1.x * 2.5;
    t16_1.x = exp2(t16_1.x);
    t16_1.xy = t16_1.xx * vec2(0.049999997, 0.0314159282);
    t2.xyz = in_POSITION0.yyy * _Object2World[1].xyz;
    t2.xyz = _Object2World[0].xyz * in_POSITION0.xxx + t2.xyz;
    t2.xyz = _Object2World[2].xyz * in_POSITION0.zzz + t2.xyz;
    t21 = dot(t2.xyz, t2.xyz);
    t21 = inversesqrt(t21);
    t2.xzw = vec3(t21) * t2.xyz;
    tb3 = t2.z>=0.0;
    if(tb3){
        t3.x = t2.z * t2.z + 0.0506249666;
        t3.x = sqrt(t3.x);
        t3.x = (-t2.y) * t21 + t3.x;
        t21 = (-t2.y) * t21 + 1.0;
        t9 = t21 * 5.25 + -6.80000019;
        t9 = t21 * t9 + 3.82999992;
        t9 = t21 * t9 + 0.458999991;
        t21 = t21 * t9 + -0.00286999997;
        t21 = t21 * 1.44269502;
        t21 = exp2(t21);
        t21 = t21 * 0.246031836;
        t3.xy = t3.xx * vec2(0.5, 20.0);
        t4.xyz = t2.xzw * t3.xxx;
        t4.xyz = t4.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t9 = dot(t4.xyz, t4.xyz);
        t9 = sqrt(t9);
        t17 = (-t9) + 1.0;
        t17 = t17 * 230.831207;
        t17 = exp2(t17);
        t24 = dot(_WorldSpaceLightPos0.xyz, t4.xyz);
        t24 = t24 / t9;
        t25 = dot(t2.xzw, t4.xyz);
        t9 = t25 / t9;
        t24 = (-t24) + 1.0;
        t25 = t24 * 5.25 + -6.80000019;
        t25 = t24 * t25 + 3.82999992;
        t25 = t24 * t25 + 0.458999991;
        t24 = t24 * t25 + -0.00286999997;
        t24 = t24 * 1.44269502;
        t24 = exp2(t24);
        t9 = (-t9) + 1.0;
        t25 = t9 * 5.25 + -6.80000019;
        t25 = t9 * t25 + 3.82999992;
        t25 = t9 * t25 + 0.458999991;
        t9 = t9 * t25 + -0.00286999997;
        t9 = t9 * 1.44269502;
        t9 = exp2(t9);
        t9 = t9 * 0.25;
        t9 = t24 * 0.25 + (-t9);
        t9 = t17 * t9 + t21;
        t9 = max(t9, 0.0);
        t9 = min(t9, 50.0);
        t5.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t6.xyz = (-vec3(t9)) * t5.xyz;
        t6.xyz = t6.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t6.xyz = exp2(t6.xyz);
        t9 = t3.y * t17;
        t3.xzw = t2.xzw * t3.xxx + t4.xyz;
        t4.x = dot(t3.xzw, t3.xzw);
        t4.x = sqrt(t4.x);
        t11 = (-t4.x) + 1.0;
        t11 = t11 * 230.831207;
        t11 = exp2(t11);
        t18 = dot(_WorldSpaceLightPos0.xyz, t3.xzw);
        t18 = t18 / t4.x;
        t3.x = dot(t2.xzw, t3.xzw);
        t3.x = t3.x / t4.x;
        t17 = (-t18) + 1.0;
        t24 = t17 * 5.25 + -6.80000019;
        t24 = t17 * t24 + 3.82999992;
        t24 = t17 * t24 + 0.458999991;
        t17 = t17 * t24 + -0.00286999997;
        t17 = t17 * 1.44269502;
        t17 = exp2(t17);
        t3.x = (-t3.x) + 1.0;
        t24 = t3.x * 5.25 + -6.80000019;
        t24 = t3.x * t24 + 3.82999992;
        t24 = t3.x * t24 + 0.458999991;
        t3.x = t3.x * t24 + -0.00286999997;
        t3.x = t3.x * 1.44269502;
        t3.x = exp2(t3.x);
        t3.x = t3.x * 0.25;
        t3.x = t17 * 0.25 + (-t3.x);
        t21 = t11 * t3.x + t21;
        t21 = max(t21, 0.0);
        t21 = min(t21, 50.0);
        t3.xzw = t5.xyz * (-vec3(t21));
        t3.xzw = t3.xzw * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xzw = exp2(t3.xzw);
        t21 = t3.y * t11;
        t3.xyz = vec3(t21) * t3.xzw;
        t3.xyz = t6.xyz * vec3(t9) + t3.xyz;
        t4.xyz = t0.xyz * t16_1.xxx;
        t4.xyz = t3.xyz * t4.xyz;
        t3.xyz = t3.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    } else {
        t21 = min(t2.z, -0.00100000005);
        t21 = -9.99999975e-005 / t21;
        t5.xyz = vec3(t21) * t2.xzw + vec3(0.0, 1.00010002, 0.0);
        t5.w = dot((-t2.xzw), t5.xyz);
        t5.x = dot(_WorldSpaceLightPos0.xyz, t5.xyz);
        t5.xy = (-t5.xw) + vec2(1.0, 1.0);
        t19 = t5.y * 5.25 + -6.80000019;
        t19 = t5.y * t19 + 3.82999992;
        t19 = t5.y * t19 + 0.458999991;
        t12.x = t5.y * t19 + -0.00286999997;
        t12.x = t12.x * 1.44269502;
        t5.y = exp2(t12.x);
        t19 = t5.x * 5.25 + -6.80000019;
        t19 = t5.x * t19 + 3.82999992;
        t19 = t5.x * t19 + 0.458999991;
        t5.x = t5.x * t19 + -0.00286999997;
        t5.xyz = t5.xyy * vec3(1.44269502, 0.25, 0.249900013);
        t5.x = exp2(t5.x);
        t5.x = t5.x * 0.25 + t5.y;
        t12.xz = vec2(t21) * vec2(0.5, 20.0);
        t6.xyz = t2.xzw * t12.xxx;
        t6.xyz = t6.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t21 = dot(t6.xyz, t6.xyz);
        t21 = sqrt(t21);
        t21 = (-t21) + 1.0;
        t21 = t21 * 230.831207;
        t21 = exp2(t21);
        t5.x = t21 * t5.x + (-t5.z);
        t5.x = max(t5.x, 0.0);
        t5.x = min(t5.x, 50.0);
        t6.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t5.xyz = (-t5.xxx) * t6.xyz;
        t5.xyz = t5.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xyz = exp2(t5.xyz);
        t21 = t12.z * t21;
        t5.xyz = vec3(t21) * t3.xyz;
        t0.xyz = t0.xyz * t16_1.xxx + vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t4.xyz = t0.xyz * t5.xyz;
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    //ENDIF
    }
    t16_1.xyz = vec3(_GroundColor.x, _GroundColor.y, _GroundColor.z) * t16_3.xyz + t16_4.xyz;
    vs_TEXCOORD1.xyz = t16_1.xyz * vec3(_Exposure);
    t16_1.x = dot(_WorldSpaceLightPos0.xyz, (-t2.xzw));
    t16_1.x = t16_1.x * t16_1.x;
    t16_1.x = t16_1.x * 0.75 + 0.75;
    t16_1.xyz = t16_1.xxx * t16_4.xyz;
    vs_TEXCOORD2.xyz = t16_1.xyz * vec3(_Exposure);
    t16_1.xyz = t16_3.xyz * _LightColor0.xyz;
    vs_TEXCOORD3.xyz = t16_1.xyz * vec3(_Exposure);
    vs_TEXCOORD0.xyz = (-t2.xzw);
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in mediump vec3 vs_TEXCOORD0;
in mediump vec3 vs_TEXCOORD1;
in mediump vec3 vs_TEXCOORD2;
in mediump vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec3 t16_0;
mediump vec3 t16_1;
bool tb2;
mediump vec3 t16_3;
void main()
{
    t16_0.xyz = vs_TEXCOORD0.xyz + _WorldSpaceLightPos0.xyz;
    t16_0.x = dot(t16_0.xyz, t16_0.xyz);
    t16_0.x = sqrt(t16_0.x);
    t16_3.x = float(1.0) / _SunSize;
    t16_0.x = t16_3.x * t16_0.x;
    t16_0.x = clamp(t16_0.x, 0.0, 1.0);
    t16_3.x = t16_0.x * -2.0 + 3.0;
    t16_0.x = t16_0.x * t16_0.x;
    t16_0.x = (-t16_3.x) * t16_0.x + 1.0;
    t16_0.x = t16_0.x * t16_0.x;
    t16_0.x = t16_0.x * 8000.0;
    t16_3.x = vs_TEXCOORD0.y * 50.0;
    t16_3.x = clamp(t16_3.x, 0.0, 1.0);
    t16_1.xyz = vs_TEXCOORD1.xyz + (-vs_TEXCOORD2.xyz);
    t16_3.xyz = t16_3.xxx * t16_1.xyz + vs_TEXCOORD2.xyz;
    t16_1.xyz = t16_0.xxx * vs_TEXCOORD3.xyz + t16_3.xyz;
    tb2 = vs_TEXCOORD0.y<0.0;
    SV_Target0.xyz = (bool(tb2)) ? t16_1.xyz : t16_3.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "_SUNDISK_HIGH_QUALITY" }
"!!GLES
#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform lowp vec4 unity_ColorSpaceDouble;
uniform lowp vec4 _LightColor0;
uniform mediump float _Exposure;
uniform mediump vec3 _GroundColor;
uniform mediump vec3 _SkyTint;
uniform mediump float _AtmosphereThickness;
varying mediump vec3 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 cOut_1;
  mediump vec3 cIn_2;
  highp float far_3;
  highp float kKr4PI_4;
  highp float kKrESun_5;
  highp vec3 kSkyTintInGammaSpace_6;
  highp vec4 tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_7 = (glstate_matrix_mvp * _glesVertex);
  mediump vec3 tmpvar_9;
  if ((unity_ColorSpaceDouble.x > 2.0)) {
    tmpvar_9 = pow (_SkyTint, vec3(0.4545454, 0.4545454, 0.4545454));
  } else {
    tmpvar_9 = _SkyTint;
  };
  kSkyTintInGammaSpace_6 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (1.0/(pow (mix (vec3(0.5, 0.42, 0.325), vec3(0.8, 0.72, 0.625), 
    (vec3(1.0, 1.0, 1.0) - kSkyTintInGammaSpace_6)
  ), vec3(4.0, 4.0, 4.0))));
  mediump float tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = pow (_AtmosphereThickness, 2.5);
  tmpvar_11 = (0.05 * tmpvar_12);
  kKrESun_5 = tmpvar_11;
  mediump float tmpvar_13;
  tmpvar_13 = (0.03141593 * tmpvar_12);
  kKr4PI_4 = tmpvar_13;
  highp mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_14 * _glesVertex.xyz));
  far_3 = 0.0;
  if ((tmpvar_15.y >= 0.0)) {
    highp vec3 frontColor_16;
    highp vec3 samplePoint_17;
    far_3 = (sqrt((
      (1.050625 + (tmpvar_15.y * tmpvar_15.y))
     - 1.0)) - tmpvar_15.y);
    highp float tmpvar_18;
    tmpvar_18 = (1.0 - (dot (tmpvar_15, vec3(0.0, 1.0001, 0.0)) / 1.0001));
    highp float tmpvar_19;
    tmpvar_19 = (exp((-0.00287 + 
      (tmpvar_18 * (0.459 + (tmpvar_18 * (3.83 + 
        (tmpvar_18 * (-6.8 + (tmpvar_18 * 5.25)))
      ))))
    )) * 0.2460318);
    highp float tmpvar_20;
    tmpvar_20 = (far_3 / 2.0);
    highp float tmpvar_21;
    tmpvar_21 = (tmpvar_20 * 40.00004);
    highp vec3 tmpvar_22;
    tmpvar_22 = (tmpvar_15 * tmpvar_20);
    highp vec3 tmpvar_23;
    tmpvar_23 = (vec3(0.0, 1.0001, 0.0) + (tmpvar_22 * 0.5));
    highp float tmpvar_24;
    tmpvar_24 = sqrt(dot (tmpvar_23, tmpvar_23));
    highp float tmpvar_25;
    tmpvar_25 = exp((160.0002 * (1.0 - tmpvar_24)));
    highp float tmpvar_26;
    tmpvar_26 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, tmpvar_23) / tmpvar_24));
    highp float tmpvar_27;
    tmpvar_27 = (1.0 - (dot (tmpvar_15, tmpvar_23) / tmpvar_24));
    frontColor_16 = (exp((
      -(clamp ((tmpvar_19 + (tmpvar_25 * 
        ((0.25 * exp((-0.00287 + 
          (tmpvar_26 * (0.459 + (tmpvar_26 * (3.83 + 
            (tmpvar_26 * (-6.8 + (tmpvar_26 * 5.25)))
          ))))
        ))) - (0.25 * exp((-0.00287 + 
          (tmpvar_27 * (0.459 + (tmpvar_27 * (3.83 + 
            (tmpvar_27 * (-6.8 + (tmpvar_27 * 5.25)))
          ))))
        ))))
      )), 0.0, 50.0))
     * 
      ((tmpvar_10 * kKr4PI_4) + 0.01256637)
    )) * (tmpvar_25 * tmpvar_21));
    samplePoint_17 = (tmpvar_23 + tmpvar_22);
    highp float tmpvar_28;
    tmpvar_28 = sqrt(dot (samplePoint_17, samplePoint_17));
    highp float tmpvar_29;
    tmpvar_29 = exp((160.0002 * (1.0 - tmpvar_28)));
    highp float tmpvar_30;
    tmpvar_30 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, samplePoint_17) / tmpvar_28));
    highp float tmpvar_31;
    tmpvar_31 = (1.0 - (dot (tmpvar_15, samplePoint_17) / tmpvar_28));
    frontColor_16 = (frontColor_16 + (exp(
      (-(clamp ((tmpvar_19 + 
        (tmpvar_29 * ((0.25 * exp(
          (-0.00287 + (tmpvar_30 * (0.459 + (tmpvar_30 * 
            (3.83 + (tmpvar_30 * (-6.8 + (tmpvar_30 * 5.25))))
          ))))
        )) - (0.25 * exp(
          (-0.00287 + (tmpvar_31 * (0.459 + (tmpvar_31 * 
            (3.83 + (tmpvar_31 * (-6.8 + (tmpvar_31 * 5.25))))
          ))))
        ))))
      ), 0.0, 50.0)) * ((tmpvar_10 * kKr4PI_4) + 0.01256637))
    ) * (tmpvar_29 * tmpvar_21)));
    samplePoint_17 = (samplePoint_17 + tmpvar_22);
    cIn_2 = (frontColor_16 * (tmpvar_10 * kKrESun_5));
    cOut_1 = (frontColor_16 * 0.02);
  } else {
    highp vec3 frontColor_1_32;
    far_3 = (-0.0001 / min (-0.001, tmpvar_15.y));
    highp vec3 tmpvar_33;
    tmpvar_33 = (vec3(0.0, 1.0001, 0.0) + (far_3 * tmpvar_15));
    highp float tmpvar_34;
    highp float tmpvar_35;
    tmpvar_35 = (1.0 - dot (-(tmpvar_15), tmpvar_33));
    tmpvar_34 = (0.25 * exp((-0.00287 + 
      (tmpvar_35 * (0.459 + (tmpvar_35 * (3.83 + 
        (tmpvar_35 * (-6.8 + (tmpvar_35 * 5.25)))
      ))))
    )));
    highp float tmpvar_36;
    tmpvar_36 = (1.0 - dot (_WorldSpaceLightPos0.xyz, tmpvar_33));
    highp float tmpvar_37;
    tmpvar_37 = (far_3 / 2.0);
    highp vec3 tmpvar_38;
    tmpvar_38 = (vec3(0.0, 1.0001, 0.0) + ((tmpvar_15 * tmpvar_37) * 0.5));
    highp float tmpvar_39;
    tmpvar_39 = exp((160.0002 * (1.0 - 
      sqrt(dot (tmpvar_38, tmpvar_38))
    )));
    highp vec3 tmpvar_40;
    tmpvar_40 = exp((-(
      clamp (((tmpvar_39 * (
        (0.25 * exp((-0.00287 + (tmpvar_36 * 
          (0.459 + (tmpvar_36 * (3.83 + (tmpvar_36 * 
            (-6.8 + (tmpvar_36 * 5.25))
          ))))
        ))))
       + tmpvar_34)) - (0.9996001 * tmpvar_34)), 0.0, 50.0)
    ) * (
      (tmpvar_10 * kKr4PI_4)
     + 0.01256637)));
    frontColor_1_32 = (tmpvar_40 * (tmpvar_39 * (tmpvar_37 * 40.00004)));
    cIn_2 = (frontColor_1_32 * ((tmpvar_10 * kKrESun_5) + 0.02));
    highp vec3 tmpvar_41;
    tmpvar_41 = clamp (tmpvar_40, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    cOut_1 = tmpvar_41;
  };
  highp vec3 tmpvar_42;
  tmpvar_42 = -(_glesVertex).xyz;
  tmpvar_8 = tmpvar_42;
  mediump vec3 light_43;
  light_43 = _WorldSpaceLightPos0.xyz;
  mediump vec3 ray_44;
  ray_44 = -(tmpvar_15);
  mediump float tmpvar_45;
  tmpvar_45 = dot (light_43, ray_44);
  gl_Position = tmpvar_7;
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = (_Exposure * (cIn_2 + (_GroundColor * cOut_1)));
  xlv_TEXCOORD2 = (_Exposure * (cIn_2 * (0.75 + 
    (0.75 * (tmpvar_45 * tmpvar_45))
  )));
  xlv_TEXCOORD3 = (_Exposure * (cOut_1 * _LightColor0.xyz));
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform mediump float _SunSize;
varying mediump vec3 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 col_1;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize((tmpvar_2 * xlv_TEXCOORD0));
  mediump float tmpvar_4;
  tmpvar_4 = (tmpvar_3.y / 0.02);
  mediump vec3 tmpvar_5;
  tmpvar_5 = mix (xlv_TEXCOORD2, xlv_TEXCOORD1, vec3(clamp (tmpvar_4, 0.0, 1.0)));
  col_1 = tmpvar_5;
  if ((tmpvar_4 < 0.0)) {
    mediump float eyeCos_6;
    highp float tmpvar_7;
    tmpvar_7 = dot (_WorldSpaceLightPos0.xyz, tmpvar_3);
    eyeCos_6 = tmpvar_7;
    col_1 = (tmpvar_5 + ((
      (0.01001645 * (1.0 + (eyeCos_6 * eyeCos_6)))
     / 
      max (pow ((1.9801 - (-1.98 * eyeCos_6)), (pow (_SunSize, 0.65) * 10.0)), 0.0001)
    ) * xlv_TEXCOORD3));
  };
  mediump vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = col_1;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "_SUNDISK_HIGH_QUALITY" }
"!!GLES3
#ifdef VERTEX
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in highp vec4 in_POSITION0;
out mediump vec3 vs_TEXCOORD0;
out mediump vec3 vs_TEXCOORD1;
out mediump vec3 vs_TEXCOORD2;
out mediump vec3 vs_TEXCOORD3;
highp vec4 t0;
bool tb0;
mediump vec3 t16_1;
highp vec4 t2;
highp vec4 t3;
mediump vec3 t16_3;
bool tb3;
highp vec3 t4;
mediump vec3 t16_4;
highp vec4 t5;
highp vec3 t6;
highp float t9;
highp float t11;
highp vec3 t12;
highp float t17;
highp float t18;
highp float t19;
highp float t21;
highp float t24;
highp float t25;
void main()
{
    t0 = in_POSITION0.yyyy * glstate_matrix_mvp[1];
    t0 = glstate_matrix_mvp[0] * in_POSITION0.xxxx + t0;
    t0 = glstate_matrix_mvp[2] * in_POSITION0.zzzz + t0;
    gl_Position = glstate_matrix_mvp[3] * in_POSITION0.wwww + t0;
    tb0 = 2.0<unity_ColorSpaceDouble.x;
    t16_1.xyz = log2(vec3(_SkyTint.x, _SkyTint.y, _SkyTint.z));
    t16_1.xyz = t16_1.xyz * vec3(0.454545468, 0.454545468, 0.454545468);
    t16_1.xyz = exp2(t16_1.xyz);
    t16_1.xyz = (bool(tb0)) ? t16_1.xyz : vec3(_SkyTint.x, _SkyTint.y, _SkyTint.z);
    t0.xyz = (-t16_1.xyz) + vec3(1.0, 1.0, 1.0);
    t0.xyz = t0.xyz * vec3(0.300000012, 0.300000042, 0.300000012) + vec3(0.5, 0.419999987, 0.324999988);
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = vec3(1.0, 1.0, 1.0) / t0.xyz;
    t16_1.x = log2(_AtmosphereThickness);
    t16_1.x = t16_1.x * 2.5;
    t16_1.x = exp2(t16_1.x);
    t16_1.xy = t16_1.xx * vec2(0.049999997, 0.0314159282);
    t2.xyz = in_POSITION0.yyy * _Object2World[1].xyz;
    t2.xyz = _Object2World[0].xyz * in_POSITION0.xxx + t2.xyz;
    t2.xyz = _Object2World[2].xyz * in_POSITION0.zzz + t2.xyz;
    t21 = dot(t2.xyz, t2.xyz);
    t21 = inversesqrt(t21);
    t2.xzw = vec3(t21) * t2.xyz;
    tb3 = t2.z>=0.0;
    if(tb3){
        t3.x = t2.z * t2.z + 0.0506249666;
        t3.x = sqrt(t3.x);
        t3.x = (-t2.y) * t21 + t3.x;
        t21 = (-t2.y) * t21 + 1.0;
        t9 = t21 * 5.25 + -6.80000019;
        t9 = t21 * t9 + 3.82999992;
        t9 = t21 * t9 + 0.458999991;
        t21 = t21 * t9 + -0.00286999997;
        t21 = t21 * 1.44269502;
        t21 = exp2(t21);
        t21 = t21 * 0.246031836;
        t3.xy = t3.xx * vec2(0.5, 20.0);
        t4.xyz = t2.xzw * t3.xxx;
        t4.xyz = t4.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t9 = dot(t4.xyz, t4.xyz);
        t9 = sqrt(t9);
        t17 = (-t9) + 1.0;
        t17 = t17 * 230.831207;
        t17 = exp2(t17);
        t24 = dot(_WorldSpaceLightPos0.xyz, t4.xyz);
        t24 = t24 / t9;
        t25 = dot(t2.xzw, t4.xyz);
        t9 = t25 / t9;
        t24 = (-t24) + 1.0;
        t25 = t24 * 5.25 + -6.80000019;
        t25 = t24 * t25 + 3.82999992;
        t25 = t24 * t25 + 0.458999991;
        t24 = t24 * t25 + -0.00286999997;
        t24 = t24 * 1.44269502;
        t24 = exp2(t24);
        t9 = (-t9) + 1.0;
        t25 = t9 * 5.25 + -6.80000019;
        t25 = t9 * t25 + 3.82999992;
        t25 = t9 * t25 + 0.458999991;
        t9 = t9 * t25 + -0.00286999997;
        t9 = t9 * 1.44269502;
        t9 = exp2(t9);
        t9 = t9 * 0.25;
        t9 = t24 * 0.25 + (-t9);
        t9 = t17 * t9 + t21;
        t9 = max(t9, 0.0);
        t9 = min(t9, 50.0);
        t5.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t6.xyz = (-vec3(t9)) * t5.xyz;
        t6.xyz = t6.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t6.xyz = exp2(t6.xyz);
        t9 = t3.y * t17;
        t3.xzw = t2.xzw * t3.xxx + t4.xyz;
        t4.x = dot(t3.xzw, t3.xzw);
        t4.x = sqrt(t4.x);
        t11 = (-t4.x) + 1.0;
        t11 = t11 * 230.831207;
        t11 = exp2(t11);
        t18 = dot(_WorldSpaceLightPos0.xyz, t3.xzw);
        t18 = t18 / t4.x;
        t3.x = dot(t2.xzw, t3.xzw);
        t3.x = t3.x / t4.x;
        t17 = (-t18) + 1.0;
        t24 = t17 * 5.25 + -6.80000019;
        t24 = t17 * t24 + 3.82999992;
        t24 = t17 * t24 + 0.458999991;
        t17 = t17 * t24 + -0.00286999997;
        t17 = t17 * 1.44269502;
        t17 = exp2(t17);
        t3.x = (-t3.x) + 1.0;
        t24 = t3.x * 5.25 + -6.80000019;
        t24 = t3.x * t24 + 3.82999992;
        t24 = t3.x * t24 + 0.458999991;
        t3.x = t3.x * t24 + -0.00286999997;
        t3.x = t3.x * 1.44269502;
        t3.x = exp2(t3.x);
        t3.x = t3.x * 0.25;
        t3.x = t17 * 0.25 + (-t3.x);
        t21 = t11 * t3.x + t21;
        t21 = max(t21, 0.0);
        t21 = min(t21, 50.0);
        t3.xzw = t5.xyz * (-vec3(t21));
        t3.xzw = t3.xzw * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xzw = exp2(t3.xzw);
        t21 = t3.y * t11;
        t3.xyz = vec3(t21) * t3.xzw;
        t3.xyz = t6.xyz * vec3(t9) + t3.xyz;
        t4.xyz = t0.xyz * t16_1.xxx;
        t4.xyz = t3.xyz * t4.xyz;
        t3.xyz = t3.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    } else {
        t21 = min(t2.z, -0.00100000005);
        t21 = -9.99999975e-005 / t21;
        t5.xyz = vec3(t21) * t2.xzw + vec3(0.0, 1.00010002, 0.0);
        t5.w = dot((-t2.xzw), t5.xyz);
        t5.x = dot(_WorldSpaceLightPos0.xyz, t5.xyz);
        t5.xy = (-t5.xw) + vec2(1.0, 1.0);
        t19 = t5.y * 5.25 + -6.80000019;
        t19 = t5.y * t19 + 3.82999992;
        t19 = t5.y * t19 + 0.458999991;
        t12.x = t5.y * t19 + -0.00286999997;
        t12.x = t12.x * 1.44269502;
        t5.y = exp2(t12.x);
        t19 = t5.x * 5.25 + -6.80000019;
        t19 = t5.x * t19 + 3.82999992;
        t19 = t5.x * t19 + 0.458999991;
        t5.x = t5.x * t19 + -0.00286999997;
        t5.xyz = t5.xyy * vec3(1.44269502, 0.25, 0.249900013);
        t5.x = exp2(t5.x);
        t5.x = t5.x * 0.25 + t5.y;
        t12.xz = vec2(t21) * vec2(0.5, 20.0);
        t6.xyz = t2.xzw * t12.xxx;
        t6.xyz = t6.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t21 = dot(t6.xyz, t6.xyz);
        t21 = sqrt(t21);
        t21 = (-t21) + 1.0;
        t21 = t21 * 230.831207;
        t21 = exp2(t21);
        t5.x = t21 * t5.x + (-t5.z);
        t5.x = max(t5.x, 0.0);
        t5.x = min(t5.x, 50.0);
        t6.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t5.xyz = (-t5.xxx) * t6.xyz;
        t5.xyz = t5.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xyz = exp2(t5.xyz);
        t21 = t12.z * t21;
        t5.xyz = vec3(t21) * t3.xyz;
        t0.xyz = t0.xyz * t16_1.xxx + vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t4.xyz = t0.xyz * t5.xyz;
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    //ENDIF
    }
    t16_1.xyz = vec3(_GroundColor.x, _GroundColor.y, _GroundColor.z) * t16_3.xyz + t16_4.xyz;
    vs_TEXCOORD1.xyz = t16_1.xyz * vec3(_Exposure);
    t16_1.x = dot(_WorldSpaceLightPos0.xyz, (-t2.xzw));
    t16_1.x = t16_1.x * t16_1.x;
    t16_1.x = t16_1.x * 0.75 + 0.75;
    t16_1.xyz = t16_1.xxx * t16_4.xyz;
    vs_TEXCOORD2.xyz = t16_1.xyz * vec3(_Exposure);
    t16_1.xyz = t16_3.xyz * _LightColor0.xyz;
    vs_TEXCOORD3.xyz = t16_1.xyz * vec3(_Exposure);
    vs_TEXCOORD0.xyz = (-in_POSITION0.xyz);
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in mediump vec3 vs_TEXCOORD0;
in mediump vec3 vs_TEXCOORD1;
in mediump vec3 vs_TEXCOORD2;
in mediump vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec3 t16_0;
highp vec3 t1;
bool tb1;
mediump vec3 t16_2;
mediump vec3 t16_3;
highp float t10;
void main()
{
    t16_0.x = log2(_SunSize);
    t16_0.x = t16_0.x * 0.649999976;
    t16_0.x = exp2(t16_0.x);
    t1.xyz = vs_TEXCOORD0.yyy * _Object2World[1].xyz;
    t1.xyz = _Object2World[0].xyz * vs_TEXCOORD0.xxx + t1.xyz;
    t1.xyz = _Object2World[2].xyz * vs_TEXCOORD0.zzz + t1.xyz;
    t10 = dot(t1.xyz, t1.xyz);
    t10 = inversesqrt(t10);
    t1.xyz = vec3(t10) * t1.xyz;
    t1.x = dot(_WorldSpaceLightPos0.xyz, t1.xyz);
    t16_3.x = (-t1.x) * -1.98000002 + 1.98010004;
    t16_0.z = t1.x * t1.x + 1.0;
    t16_0.xz = t16_0.xz * vec2(10.0, 0.0100164423);
    t16_3.x = log2(t16_3.x);
    t16_0.x = t16_3.x * t16_0.x;
    t16_0.x = exp2(t16_0.x);
    t16_0.x = max(t16_0.x, 9.99999975e-005);
    t16_0.x = t16_0.z / t16_0.x;
    t16_3.x = t1.y * 50.0;
    t16_3.x = clamp(t16_3.x, 0.0, 1.0);
    tb1 = t1.y<0.0;
    t16_2.xyz = vs_TEXCOORD1.xyz + (-vs_TEXCOORD2.xyz);
    t16_3.xyz = t16_3.xxx * t16_2.xyz + vs_TEXCOORD2.xyz;
    t16_2.xyz = t16_0.xxx * vs_TEXCOORD3.xyz + t16_3.xyz;
    SV_Target0.xyz = (bool(tb1)) ? t16_2.xyz : t16_3.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_NONE" }
"!!GLES
#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform mediump float _Exposure;
uniform mediump vec3 _GroundColor;
uniform mediump vec3 _SkyTint;
uniform mediump float _AtmosphereThickness;
varying mediump float xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 cOut_1;
  mediump vec3 cIn_2;
  highp float far_3;
  highp float kKr4PI_4;
  highp float kKrESun_5;
  highp vec3 kSkyTintInGammaSpace_6;
  highp vec4 tmpvar_7;
  mediump float tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_7 = (glstate_matrix_mvp * _glesVertex);
  kSkyTintInGammaSpace_6 = _SkyTint;
  highp vec3 tmpvar_11;
  tmpvar_11 = (1.0/(pow (mix (vec3(0.5, 0.42, 0.325), vec3(0.8, 0.72, 0.625), 
    (vec3(1.0, 1.0, 1.0) - kSkyTintInGammaSpace_6)
  ), vec3(4.0, 4.0, 4.0))));
  mediump float tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = pow (_AtmosphereThickness, 2.5);
  tmpvar_12 = (0.05 * tmpvar_13);
  kKrESun_5 = tmpvar_12;
  mediump float tmpvar_14;
  tmpvar_14 = (0.03141593 * tmpvar_13);
  kKr4PI_4 = tmpvar_14;
  highp mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_15 * _glesVertex.xyz));
  far_3 = 0.0;
  if ((tmpvar_16.y >= 0.0)) {
    highp vec3 frontColor_17;
    highp vec3 samplePoint_18;
    far_3 = (sqrt((
      (1.050625 + (tmpvar_16.y * tmpvar_16.y))
     - 1.0)) - tmpvar_16.y);
    highp float tmpvar_19;
    tmpvar_19 = (1.0 - (dot (tmpvar_16, vec3(0.0, 1.0001, 0.0)) / 1.0001));
    highp float tmpvar_20;
    tmpvar_20 = (exp((-0.00287 + 
      (tmpvar_19 * (0.459 + (tmpvar_19 * (3.83 + 
        (tmpvar_19 * (-6.8 + (tmpvar_19 * 5.25)))
      ))))
    )) * 0.2460318);
    highp float tmpvar_21;
    tmpvar_21 = (far_3 / 2.0);
    highp float tmpvar_22;
    tmpvar_22 = (tmpvar_21 * 40.00004);
    highp vec3 tmpvar_23;
    tmpvar_23 = (tmpvar_16 * tmpvar_21);
    highp vec3 tmpvar_24;
    tmpvar_24 = (vec3(0.0, 1.0001, 0.0) + (tmpvar_23 * 0.5));
    highp float tmpvar_25;
    tmpvar_25 = sqrt(dot (tmpvar_24, tmpvar_24));
    highp float tmpvar_26;
    tmpvar_26 = exp((160.0002 * (1.0 - tmpvar_25)));
    highp float tmpvar_27;
    tmpvar_27 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, tmpvar_24) / tmpvar_25));
    highp float tmpvar_28;
    tmpvar_28 = (1.0 - (dot (tmpvar_16, tmpvar_24) / tmpvar_25));
    frontColor_17 = (exp((
      -(clamp ((tmpvar_20 + (tmpvar_26 * 
        ((0.25 * exp((-0.00287 + 
          (tmpvar_27 * (0.459 + (tmpvar_27 * (3.83 + 
            (tmpvar_27 * (-6.8 + (tmpvar_27 * 5.25)))
          ))))
        ))) - (0.25 * exp((-0.00287 + 
          (tmpvar_28 * (0.459 + (tmpvar_28 * (3.83 + 
            (tmpvar_28 * (-6.8 + (tmpvar_28 * 5.25)))
          ))))
        ))))
      )), 0.0, 50.0))
     * 
      ((tmpvar_11 * kKr4PI_4) + 0.01256637)
    )) * (tmpvar_26 * tmpvar_22));
    samplePoint_18 = (tmpvar_24 + tmpvar_23);
    highp float tmpvar_29;
    tmpvar_29 = sqrt(dot (samplePoint_18, samplePoint_18));
    highp float tmpvar_30;
    tmpvar_30 = exp((160.0002 * (1.0 - tmpvar_29)));
    highp float tmpvar_31;
    tmpvar_31 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, samplePoint_18) / tmpvar_29));
    highp float tmpvar_32;
    tmpvar_32 = (1.0 - (dot (tmpvar_16, samplePoint_18) / tmpvar_29));
    frontColor_17 = (frontColor_17 + (exp(
      (-(clamp ((tmpvar_20 + 
        (tmpvar_30 * ((0.25 * exp(
          (-0.00287 + (tmpvar_31 * (0.459 + (tmpvar_31 * 
            (3.83 + (tmpvar_31 * (-6.8 + (tmpvar_31 * 5.25))))
          ))))
        )) - (0.25 * exp(
          (-0.00287 + (tmpvar_32 * (0.459 + (tmpvar_32 * 
            (3.83 + (tmpvar_32 * (-6.8 + (tmpvar_32 * 5.25))))
          ))))
        ))))
      ), 0.0, 50.0)) * ((tmpvar_11 * kKr4PI_4) + 0.01256637))
    ) * (tmpvar_30 * tmpvar_22)));
    samplePoint_18 = (samplePoint_18 + tmpvar_23);
    cIn_2 = (frontColor_17 * (tmpvar_11 * kKrESun_5));
    cOut_1 = (frontColor_17 * 0.02);
  } else {
    highp vec3 frontColor_1_33;
    far_3 = (-0.0001 / min (-0.001, tmpvar_16.y));
    highp vec3 tmpvar_34;
    tmpvar_34 = (vec3(0.0, 1.0001, 0.0) + (far_3 * tmpvar_16));
    highp float tmpvar_35;
    highp float tmpvar_36;
    tmpvar_36 = (1.0 - dot (-(tmpvar_16), tmpvar_34));
    tmpvar_35 = (0.25 * exp((-0.00287 + 
      (tmpvar_36 * (0.459 + (tmpvar_36 * (3.83 + 
        (tmpvar_36 * (-6.8 + (tmpvar_36 * 5.25)))
      ))))
    )));
    highp float tmpvar_37;
    tmpvar_37 = (1.0 - dot (_WorldSpaceLightPos0.xyz, tmpvar_34));
    highp float tmpvar_38;
    tmpvar_38 = (far_3 / 2.0);
    highp vec3 tmpvar_39;
    tmpvar_39 = (vec3(0.0, 1.0001, 0.0) + ((tmpvar_16 * tmpvar_38) * 0.5));
    highp float tmpvar_40;
    tmpvar_40 = exp((160.0002 * (1.0 - 
      sqrt(dot (tmpvar_39, tmpvar_39))
    )));
    highp vec3 tmpvar_41;
    tmpvar_41 = exp((-(
      clamp (((tmpvar_40 * (
        (0.25 * exp((-0.00287 + (tmpvar_37 * 
          (0.459 + (tmpvar_37 * (3.83 + (tmpvar_37 * 
            (-6.8 + (tmpvar_37 * 5.25))
          ))))
        ))))
       + tmpvar_35)) - (0.9996001 * tmpvar_35)), 0.0, 50.0)
    ) * (
      (tmpvar_11 * kKr4PI_4)
     + 0.01256637)));
    frontColor_1_33 = (tmpvar_41 * (tmpvar_40 * (tmpvar_38 * 40.00004)));
    cIn_2 = (frontColor_1_33 * ((tmpvar_11 * kKrESun_5) + 0.02));
    highp vec3 tmpvar_42;
    tmpvar_42 = clamp (tmpvar_41, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    cOut_1 = tmpvar_42;
  };
  tmpvar_8 = (-(tmpvar_16.y) / 0.02);
  tmpvar_9 = (_Exposure * (cIn_2 + (
    (_GroundColor * _GroundColor)
   * cOut_1)));
  mediump vec3 light_43;
  light_43 = _WorldSpaceLightPos0.xyz;
  mediump vec3 ray_44;
  ray_44 = -(tmpvar_16);
  mediump float tmpvar_45;
  tmpvar_45 = dot (light_43, ray_44);
  tmpvar_10 = (_Exposure * (cIn_2 * (0.75 + 
    (0.75 * (tmpvar_45 * tmpvar_45))
  )));
  mediump vec3 tmpvar_46;
  tmpvar_46 = sqrt(tmpvar_9);
  tmpvar_9 = tmpvar_46;
  mediump vec3 tmpvar_47;
  tmpvar_47 = sqrt(tmpvar_10);
  tmpvar_10 = tmpvar_47;
  gl_Position = tmpvar_7;
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = tmpvar_46;
  xlv_TEXCOORD2 = tmpvar_47;
}


#endif
#ifdef FRAGMENT
varying mediump float xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = mix (xlv_TEXCOORD2, xlv_TEXCOORD1, vec3(clamp (xlv_TEXCOORD0, 0.0, 1.0)));
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_NONE" }
"!!GLES3
#ifdef VERTEX
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in highp vec4 in_POSITION0;
out mediump float vs_TEXCOORD0;
out mediump vec3 vs_TEXCOORD1;
out mediump vec3 vs_TEXCOORD2;
highp vec4 t0;
mediump vec3 t16_1;
highp vec4 t2;
highp vec4 t3;
mediump vec3 t16_3;
bool tb3;
highp vec3 t4;
mediump vec3 t16_4;
highp vec4 t5;
highp vec3 t6;
mediump vec3 t16_7;
highp float t10;
highp float t12;
highp vec3 t13;
highp float t19;
highp float t20;
highp float t21;
highp float t24;
mediump float t16_25;
highp float t27;
highp float t28;
void main()
{
    t0 = in_POSITION0.yyyy * glstate_matrix_mvp[1];
    t0 = glstate_matrix_mvp[0] * in_POSITION0.xxxx + t0;
    t0 = glstate_matrix_mvp[2] * in_POSITION0.zzzz + t0;
    gl_Position = glstate_matrix_mvp[3] * in_POSITION0.wwww + t0;
    t0.xyz = vec3((-_SkyTint.xxyz.y) + float(1.0), (-_SkyTint.xxyz.z) + float(1.0), (-float(_SkyTint.z)) + float(1.0));
    t0.xyz = t0.xyz * vec3(0.300000012, 0.300000042, 0.300000012) + vec3(0.5, 0.419999987, 0.324999988);
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = vec3(1.0, 1.0, 1.0) / t0.xyz;
    t16_1.x = log2(_AtmosphereThickness);
    t16_1.x = t16_1.x * 2.5;
    t16_1.x = exp2(t16_1.x);
    t16_1.xy = t16_1.xx * vec2(0.049999997, 0.0314159282);
    t2.xyz = in_POSITION0.yyy * _Object2World[1].xyz;
    t2.xyz = _Object2World[0].xyz * in_POSITION0.xxx + t2.xyz;
    t2.xyz = _Object2World[2].xyz * in_POSITION0.zzz + t2.xyz;
    t24 = dot(t2.xyz, t2.xyz);
    t24 = inversesqrt(t24);
    t2.xzw = vec3(t24) * t2.xyz;
    tb3 = t2.z>=0.0;
    if(tb3){
        t3.x = t2.z * t2.z + 0.0506249666;
        t3.x = sqrt(t3.x);
        t24 = (-t2.y) * t24 + t3.x;
        t10 = (-t2.z) * 1.0 + 1.0;
        t3.x = t10 * 5.25 + -6.80000019;
        t3.x = t10 * t3.x + 3.82999992;
        t3.x = t10 * t3.x + 0.458999991;
        t10 = t10 * t3.x + -0.00286999997;
        t10 = t10 * 1.44269502;
        t10 = exp2(t10);
        t10 = t10 * 0.246031836;
        t3.xy = vec2(t24) * vec2(0.5, 20.0);
        t4.xyz = t2.xzw * t3.xxx;
        t4.xyz = t4.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t24 = dot(t4.xyz, t4.xyz);
        t24 = sqrt(t24);
        t19 = (-t24) + 1.0;
        t19 = t19 * 230.831207;
        t19 = exp2(t19);
        t27 = dot(_WorldSpaceLightPos0.xyz, t4.xyz);
        t27 = t27 / t24;
        t28 = dot(t2.xzw, t4.xyz);
        t24 = t28 / t24;
        t27 = (-t27) + 1.0;
        t28 = t27 * 5.25 + -6.80000019;
        t28 = t27 * t28 + 3.82999992;
        t28 = t27 * t28 + 0.458999991;
        t27 = t27 * t28 + -0.00286999997;
        t27 = t27 * 1.44269502;
        t27 = exp2(t27);
        t24 = (-t24) + 1.0;
        t28 = t24 * 5.25 + -6.80000019;
        t28 = t24 * t28 + 3.82999992;
        t28 = t24 * t28 + 0.458999991;
        t24 = t24 * t28 + -0.00286999997;
        t24 = t24 * 1.44269502;
        t24 = exp2(t24);
        t24 = t24 * 0.25;
        t24 = t27 * 0.25 + (-t24);
        t24 = t19 * t24 + t10;
        t24 = max(t24, 0.0);
        t24 = min(t24, 50.0);
        t5.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t6.xyz = (-vec3(t24)) * t5.xyz;
        t6.xyz = t6.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t6.xyz = exp2(t6.xyz);
        t24 = t3.y * t19;
        t3.xzw = t2.xzw * t3.xxx + t4.xyz;
        t4.x = dot(t3.xzw, t3.xzw);
        t4.x = sqrt(t4.x);
        t12 = (-t4.x) + 1.0;
        t12 = t12 * 230.831207;
        t12 = exp2(t12);
        t20 = dot(_WorldSpaceLightPos0.xyz, t3.xzw);
        t20 = t20 / t4.x;
        t3.x = dot(t2.xzw, t3.xzw);
        t3.x = t3.x / t4.x;
        t19 = (-t20) + 1.0;
        t27 = t19 * 5.25 + -6.80000019;
        t27 = t19 * t27 + 3.82999992;
        t27 = t19 * t27 + 0.458999991;
        t19 = t19 * t27 + -0.00286999997;
        t19 = t19 * 1.44269502;
        t19 = exp2(t19);
        t3.x = (-t3.x) + 1.0;
        t27 = t3.x * 5.25 + -6.80000019;
        t27 = t3.x * t27 + 3.82999992;
        t27 = t3.x * t27 + 0.458999991;
        t3.x = t3.x * t27 + -0.00286999997;
        t3.x = t3.x * 1.44269502;
        t3.x = exp2(t3.x);
        t3.x = t3.x * 0.25;
        t3.x = t19 * 0.25 + (-t3.x);
        t10 = t12 * t3.x + t10;
        t10 = max(t10, 0.0);
        t10 = min(t10, 50.0);
        t3.xzw = t5.xyz * (-vec3(t10));
        t3.xzw = t3.xzw * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xzw = exp2(t3.xzw);
        t10 = t3.y * t12;
        t3.xyz = vec3(t10) * t3.xzw;
        t3.xyz = t6.xyz * vec3(t24) + t3.xyz;
        t4.xyz = t0.xyz * t16_1.xxx;
        t4.xyz = t3.xyz * t4.xyz;
        t3.xyz = t3.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    } else {
        t10 = min(t2.z, -0.00100000005);
        t10 = -9.99999975e-005 / t10;
        t5.xyz = vec3(t10) * t2.xzw + vec3(0.0, 1.00010002, 0.0);
        t5.w = dot((-t2.xzw), t5.xyz);
        t5.x = dot(_WorldSpaceLightPos0.xyz, t5.xyz);
        t5.xy = (-t5.xw) + vec2(1.0, 1.0);
        t21 = t5.y * 5.25 + -6.80000019;
        t21 = t5.y * t21 + 3.82999992;
        t21 = t5.y * t21 + 0.458999991;
        t13.x = t5.y * t21 + -0.00286999997;
        t13.x = t13.x * 1.44269502;
        t5.y = exp2(t13.x);
        t21 = t5.x * 5.25 + -6.80000019;
        t21 = t5.x * t21 + 3.82999992;
        t21 = t5.x * t21 + 0.458999991;
        t5.x = t5.x * t21 + -0.00286999997;
        t5.xyz = t5.xyy * vec3(1.44269502, 0.25, 0.249900013);
        t5.x = exp2(t5.x);
        t5.x = t5.x * 0.25 + t5.y;
        t13.xz = vec2(t10) * vec2(0.5, 20.0);
        t6.xyz = t2.xzw * t13.xxx;
        t6.xyz = t6.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t10 = dot(t6.xyz, t6.xyz);
        t10 = sqrt(t10);
        t10 = (-t10) + 1.0;
        t10 = t10 * 230.831207;
        t10 = exp2(t10);
        t5.x = t10 * t5.x + (-t5.z);
        t5.x = max(t5.x, 0.0);
        t5.x = min(t5.x, 50.0);
        t6.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t5.xyz = (-t5.xxx) * t6.xyz;
        t5.xyz = t5.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xyz = exp2(t5.xyz);
        t10 = t13.z * t10;
        t5.xyz = vec3(t10) * t3.xyz;
        t6.xyz = t0.xyz * t16_1.xxx + vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t4.xyz = t5.xyz * t6.xyz;
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    //ENDIF
    }
    t10 = t2.z * -50.0;
    t16_1.xyz = vec3(_GroundColor.xxyz.y * _GroundColor.xxyz.y, _GroundColor.xxyz.z * _GroundColor.xxyz.z, float(_GroundColor.z) * float(_GroundColor.z));
    t16_1.xyz = t16_1.xyz * t16_3.xyz + t16_4.xyz;
    t16_1.xyz = t16_1.xyz * vec3(_Exposure);
    t16_25 = dot(_WorldSpaceLightPos0.xyz, (-t2.xzw));
    t16_25 = t16_25 * t16_25;
    t16_25 = t16_25 * 0.75 + 0.75;
    t16_7.xyz = vec3(t16_25) * t16_4.xyz;
    t16_7.xyz = t16_7.xyz * vec3(_Exposure);
    vs_TEXCOORD1.xyz = sqrt(t16_1.xyz);
    vs_TEXCOORD2.xyz = sqrt(t16_7.xyz);
    vs_TEXCOORD0 = t10;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es
precision highp float;
precision highp int;
in mediump float vs_TEXCOORD0;
in mediump vec3 vs_TEXCOORD1;
in mediump vec3 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
mediump float t16_0;
mediump vec3 t16_1;
void main()
{
    t16_0 = vs_TEXCOORD0;
    t16_0 = clamp(t16_0, 0.0, 1.0);
    t16_1.xyz = vec3(vs_TEXCOORD1.x + (-vs_TEXCOORD2.x), vs_TEXCOORD1.y + (-vs_TEXCOORD2.y), vs_TEXCOORD1.z + (-vs_TEXCOORD2.z));
    SV_Target0.xyz = vec3(t16_0) * t16_1.xyz + vs_TEXCOORD2.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_SIMPLE" }
"!!GLES
#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform lowp vec4 _LightColor0;
uniform mediump float _Exposure;
uniform mediump vec3 _GroundColor;
uniform mediump vec3 _SkyTint;
uniform mediump float _AtmosphereThickness;
varying mediump vec3 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 cOut_1;
  mediump vec3 cIn_2;
  highp float far_3;
  highp float kKr4PI_4;
  highp float kKrESun_5;
  highp vec3 kSkyTintInGammaSpace_6;
  highp vec4 tmpvar_7;
  mediump vec3 tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_7 = (glstate_matrix_mvp * _glesVertex);
  kSkyTintInGammaSpace_6 = _SkyTint;
  highp vec3 tmpvar_12;
  tmpvar_12 = (1.0/(pow (mix (vec3(0.5, 0.42, 0.325), vec3(0.8, 0.72, 0.625), 
    (vec3(1.0, 1.0, 1.0) - kSkyTintInGammaSpace_6)
  ), vec3(4.0, 4.0, 4.0))));
  mediump float tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = pow (_AtmosphereThickness, 2.5);
  tmpvar_13 = (0.05 * tmpvar_14);
  kKrESun_5 = tmpvar_13;
  mediump float tmpvar_15;
  tmpvar_15 = (0.03141593 * tmpvar_14);
  kKr4PI_4 = tmpvar_15;
  highp mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_16 * _glesVertex.xyz));
  far_3 = 0.0;
  if ((tmpvar_17.y >= 0.0)) {
    highp vec3 frontColor_18;
    highp vec3 samplePoint_19;
    far_3 = (sqrt((
      (1.050625 + (tmpvar_17.y * tmpvar_17.y))
     - 1.0)) - tmpvar_17.y);
    highp float tmpvar_20;
    tmpvar_20 = (1.0 - (dot (tmpvar_17, vec3(0.0, 1.0001, 0.0)) / 1.0001));
    highp float tmpvar_21;
    tmpvar_21 = (exp((-0.00287 + 
      (tmpvar_20 * (0.459 + (tmpvar_20 * (3.83 + 
        (tmpvar_20 * (-6.8 + (tmpvar_20 * 5.25)))
      ))))
    )) * 0.2460318);
    highp float tmpvar_22;
    tmpvar_22 = (far_3 / 2.0);
    highp float tmpvar_23;
    tmpvar_23 = (tmpvar_22 * 40.00004);
    highp vec3 tmpvar_24;
    tmpvar_24 = (tmpvar_17 * tmpvar_22);
    highp vec3 tmpvar_25;
    tmpvar_25 = (vec3(0.0, 1.0001, 0.0) + (tmpvar_24 * 0.5));
    highp float tmpvar_26;
    tmpvar_26 = sqrt(dot (tmpvar_25, tmpvar_25));
    highp float tmpvar_27;
    tmpvar_27 = exp((160.0002 * (1.0 - tmpvar_26)));
    highp float tmpvar_28;
    tmpvar_28 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, tmpvar_25) / tmpvar_26));
    highp float tmpvar_29;
    tmpvar_29 = (1.0 - (dot (tmpvar_17, tmpvar_25) / tmpvar_26));
    frontColor_18 = (exp((
      -(clamp ((tmpvar_21 + (tmpvar_27 * 
        ((0.25 * exp((-0.00287 + 
          (tmpvar_28 * (0.459 + (tmpvar_28 * (3.83 + 
            (tmpvar_28 * (-6.8 + (tmpvar_28 * 5.25)))
          ))))
        ))) - (0.25 * exp((-0.00287 + 
          (tmpvar_29 * (0.459 + (tmpvar_29 * (3.83 + 
            (tmpvar_29 * (-6.8 + (tmpvar_29 * 5.25)))
          ))))
        ))))
      )), 0.0, 50.0))
     * 
      ((tmpvar_12 * kKr4PI_4) + 0.01256637)
    )) * (tmpvar_27 * tmpvar_23));
    samplePoint_19 = (tmpvar_25 + tmpvar_24);
    highp float tmpvar_30;
    tmpvar_30 = sqrt(dot (samplePoint_19, samplePoint_19));
    highp float tmpvar_31;
    tmpvar_31 = exp((160.0002 * (1.0 - tmpvar_30)));
    highp float tmpvar_32;
    tmpvar_32 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, samplePoint_19) / tmpvar_30));
    highp float tmpvar_33;
    tmpvar_33 = (1.0 - (dot (tmpvar_17, samplePoint_19) / tmpvar_30));
    frontColor_18 = (frontColor_18 + (exp(
      (-(clamp ((tmpvar_21 + 
        (tmpvar_31 * ((0.25 * exp(
          (-0.00287 + (tmpvar_32 * (0.459 + (tmpvar_32 * 
            (3.83 + (tmpvar_32 * (-6.8 + (tmpvar_32 * 5.25))))
          ))))
        )) - (0.25 * exp(
          (-0.00287 + (tmpvar_33 * (0.459 + (tmpvar_33 * 
            (3.83 + (tmpvar_33 * (-6.8 + (tmpvar_33 * 5.25))))
          ))))
        ))))
      ), 0.0, 50.0)) * ((tmpvar_12 * kKr4PI_4) + 0.01256637))
    ) * (tmpvar_31 * tmpvar_23)));
    samplePoint_19 = (samplePoint_19 + tmpvar_24);
    cIn_2 = (frontColor_18 * (tmpvar_12 * kKrESun_5));
    cOut_1 = (frontColor_18 * 0.02);
  } else {
    highp vec3 frontColor_1_34;
    far_3 = (-0.0001 / min (-0.001, tmpvar_17.y));
    highp vec3 tmpvar_35;
    tmpvar_35 = (vec3(0.0, 1.0001, 0.0) + (far_3 * tmpvar_17));
    highp float tmpvar_36;
    highp float tmpvar_37;
    tmpvar_37 = (1.0 - dot (-(tmpvar_17), tmpvar_35));
    tmpvar_36 = (0.25 * exp((-0.00287 + 
      (tmpvar_37 * (0.459 + (tmpvar_37 * (3.83 + 
        (tmpvar_37 * (-6.8 + (tmpvar_37 * 5.25)))
      ))))
    )));
    highp float tmpvar_38;
    tmpvar_38 = (1.0 - dot (_WorldSpaceLightPos0.xyz, tmpvar_35));
    highp float tmpvar_39;
    tmpvar_39 = (far_3 / 2.0);
    highp vec3 tmpvar_40;
    tmpvar_40 = (vec3(0.0, 1.0001, 0.0) + ((tmpvar_17 * tmpvar_39) * 0.5));
    highp float tmpvar_41;
    tmpvar_41 = exp((160.0002 * (1.0 - 
      sqrt(dot (tmpvar_40, tmpvar_40))
    )));
    highp vec3 tmpvar_42;
    tmpvar_42 = exp((-(
      clamp (((tmpvar_41 * (
        (0.25 * exp((-0.00287 + (tmpvar_38 * 
          (0.459 + (tmpvar_38 * (3.83 + (tmpvar_38 * 
            (-6.8 + (tmpvar_38 * 5.25))
          ))))
        ))))
       + tmpvar_36)) - (0.9996001 * tmpvar_36)), 0.0, 50.0)
    ) * (
      (tmpvar_12 * kKr4PI_4)
     + 0.01256637)));
    frontColor_1_34 = (tmpvar_42 * (tmpvar_41 * (tmpvar_39 * 40.00004)));
    cIn_2 = (frontColor_1_34 * ((tmpvar_12 * kKrESun_5) + 0.02));
    highp vec3 tmpvar_43;
    tmpvar_43 = clamp (tmpvar_42, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    cOut_1 = tmpvar_43;
  };
  tmpvar_8 = -(tmpvar_17);
  tmpvar_9 = (_Exposure * (cIn_2 + (
    (_GroundColor * _GroundColor)
   * cOut_1)));
  mediump vec3 light_44;
  light_44 = _WorldSpaceLightPos0.xyz;
  mediump vec3 ray_45;
  ray_45 = -(tmpvar_17);
  mediump float tmpvar_46;
  tmpvar_46 = dot (light_44, ray_45);
  tmpvar_10 = (_Exposure * (cIn_2 * (0.75 + 
    (0.75 * (tmpvar_46 * tmpvar_46))
  )));
  tmpvar_11 = (_Exposure * (cOut_1 * _LightColor0.xyz));
  mediump vec3 tmpvar_47;
  tmpvar_47 = sqrt(tmpvar_9);
  tmpvar_9 = tmpvar_47;
  mediump vec3 tmpvar_48;
  tmpvar_48 = sqrt(tmpvar_10);
  tmpvar_10 = tmpvar_48;
  mediump vec3 tmpvar_49;
  tmpvar_49 = sqrt(tmpvar_11);
  tmpvar_11 = tmpvar_49;
  gl_Position = tmpvar_7;
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = tmpvar_47;
  xlv_TEXCOORD2 = tmpvar_48;
  xlv_TEXCOORD3 = tmpvar_49;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _WorldSpaceLightPos0;
uniform mediump float _SunSize;
varying mediump vec3 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 col_1;
  mediump float tmpvar_2;
  tmpvar_2 = (xlv_TEXCOORD0.y / 0.02);
  mediump vec3 tmpvar_3;
  tmpvar_3 = mix (xlv_TEXCOORD2, xlv_TEXCOORD1, vec3(clamp (tmpvar_2, 0.0, 1.0)));
  col_1 = tmpvar_3;
  if ((tmpvar_2 < 0.0)) {
    mediump vec3 vec1_4;
    vec1_4 = _WorldSpaceLightPos0.xyz;
    mediump vec3 tmpvar_5;
    tmpvar_5 = (vec1_4 - -(xlv_TEXCOORD0));
    mediump float tmpvar_6;
    tmpvar_6 = clamp ((sqrt(
      dot (tmpvar_5, tmpvar_5)
    ) / _SunSize), 0.0, 1.0);
    mediump float tmpvar_7;
    tmpvar_7 = (1.0 - (tmpvar_6 * (tmpvar_6 * 
      (3.0 - (2.0 * tmpvar_6))
    )));
    col_1 = (tmpvar_3 + ((
      (8000.0 * tmpvar_7)
     * tmpvar_7) * xlv_TEXCOORD3));
  };
  mediump vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = col_1;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_SIMPLE" }
"!!GLES3
#ifdef VERTEX
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in highp vec4 in_POSITION0;
out mediump vec3 vs_TEXCOORD0;
out mediump vec3 vs_TEXCOORD1;
out mediump vec3 vs_TEXCOORD2;
out mediump vec3 vs_TEXCOORD3;
highp vec4 t0;
mediump vec3 t16_1;
highp vec4 t2;
highp vec4 t3;
mediump vec3 t16_3;
bool tb3;
highp vec3 t4;
mediump vec3 t16_4;
highp vec4 t5;
highp vec3 t6;
mediump vec3 t16_7;
mediump vec3 t16_8;
highp float t11;
highp float t13;
highp vec3 t14;
highp float t21;
highp float t22;
highp float t23;
highp float t27;
mediump float t16_28;
highp float t30;
highp float t31;
void main()
{
    t0 = in_POSITION0.yyyy * glstate_matrix_mvp[1];
    t0 = glstate_matrix_mvp[0] * in_POSITION0.xxxx + t0;
    t0 = glstate_matrix_mvp[2] * in_POSITION0.zzzz + t0;
    gl_Position = glstate_matrix_mvp[3] * in_POSITION0.wwww + t0;
    t0.xyz = vec3((-_SkyTint.xxyz.y) + float(1.0), (-_SkyTint.xxyz.z) + float(1.0), (-float(_SkyTint.z)) + float(1.0));
    t0.xyz = t0.xyz * vec3(0.300000012, 0.300000042, 0.300000012) + vec3(0.5, 0.419999987, 0.324999988);
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = vec3(1.0, 1.0, 1.0) / t0.xyz;
    t16_1.x = log2(_AtmosphereThickness);
    t16_1.x = t16_1.x * 2.5;
    t16_1.x = exp2(t16_1.x);
    t16_1.xy = t16_1.xx * vec2(0.049999997, 0.0314159282);
    t2.xyz = in_POSITION0.yyy * _Object2World[1].xyz;
    t2.xyz = _Object2World[0].xyz * in_POSITION0.xxx + t2.xyz;
    t2.xyz = _Object2World[2].xyz * in_POSITION0.zzz + t2.xyz;
    t27 = dot(t2.xyz, t2.xyz);
    t27 = inversesqrt(t27);
    t2.xzw = vec3(t27) * t2.xyz;
    tb3 = t2.z>=0.0;
    if(tb3){
        t3.x = t2.z * t2.z + 0.0506249666;
        t3.x = sqrt(t3.x);
        t27 = (-t2.y) * t27 + t3.x;
        t11 = (-t2.z) * 1.0 + 1.0;
        t3.x = t11 * 5.25 + -6.80000019;
        t3.x = t11 * t3.x + 3.82999992;
        t3.x = t11 * t3.x + 0.458999991;
        t11 = t11 * t3.x + -0.00286999997;
        t11 = t11 * 1.44269502;
        t11 = exp2(t11);
        t11 = t11 * 0.246031836;
        t3.xy = vec2(t27) * vec2(0.5, 20.0);
        t4.xyz = t2.xzw * t3.xxx;
        t4.xyz = t4.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t27 = dot(t4.xyz, t4.xyz);
        t27 = sqrt(t27);
        t21 = (-t27) + 1.0;
        t21 = t21 * 230.831207;
        t21 = exp2(t21);
        t30 = dot(_WorldSpaceLightPos0.xyz, t4.xyz);
        t30 = t30 / t27;
        t31 = dot(t2.xzw, t4.xyz);
        t27 = t31 / t27;
        t30 = (-t30) + 1.0;
        t31 = t30 * 5.25 + -6.80000019;
        t31 = t30 * t31 + 3.82999992;
        t31 = t30 * t31 + 0.458999991;
        t30 = t30 * t31 + -0.00286999997;
        t30 = t30 * 1.44269502;
        t30 = exp2(t30);
        t27 = (-t27) + 1.0;
        t31 = t27 * 5.25 + -6.80000019;
        t31 = t27 * t31 + 3.82999992;
        t31 = t27 * t31 + 0.458999991;
        t27 = t27 * t31 + -0.00286999997;
        t27 = t27 * 1.44269502;
        t27 = exp2(t27);
        t27 = t27 * 0.25;
        t27 = t30 * 0.25 + (-t27);
        t27 = t21 * t27 + t11;
        t27 = max(t27, 0.0);
        t27 = min(t27, 50.0);
        t5.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t6.xyz = (-vec3(t27)) * t5.xyz;
        t6.xyz = t6.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t6.xyz = exp2(t6.xyz);
        t27 = t3.y * t21;
        t3.xzw = t2.xzw * t3.xxx + t4.xyz;
        t4.x = dot(t3.xzw, t3.xzw);
        t4.x = sqrt(t4.x);
        t13 = (-t4.x) + 1.0;
        t13 = t13 * 230.831207;
        t13 = exp2(t13);
        t22 = dot(_WorldSpaceLightPos0.xyz, t3.xzw);
        t22 = t22 / t4.x;
        t3.x = dot(t2.xzw, t3.xzw);
        t3.x = t3.x / t4.x;
        t21 = (-t22) + 1.0;
        t30 = t21 * 5.25 + -6.80000019;
        t30 = t21 * t30 + 3.82999992;
        t30 = t21 * t30 + 0.458999991;
        t21 = t21 * t30 + -0.00286999997;
        t21 = t21 * 1.44269502;
        t21 = exp2(t21);
        t3.x = (-t3.x) + 1.0;
        t30 = t3.x * 5.25 + -6.80000019;
        t30 = t3.x * t30 + 3.82999992;
        t30 = t3.x * t30 + 0.458999991;
        t3.x = t3.x * t30 + -0.00286999997;
        t3.x = t3.x * 1.44269502;
        t3.x = exp2(t3.x);
        t3.x = t3.x * 0.25;
        t3.x = t21 * 0.25 + (-t3.x);
        t11 = t13 * t3.x + t11;
        t11 = max(t11, 0.0);
        t11 = min(t11, 50.0);
        t3.xzw = t5.xyz * (-vec3(t11));
        t3.xzw = t3.xzw * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xzw = exp2(t3.xzw);
        t11 = t3.y * t13;
        t3.xyz = vec3(t11) * t3.xzw;
        t3.xyz = t6.xyz * vec3(t27) + t3.xyz;
        t4.xyz = t0.xyz * t16_1.xxx;
        t4.xyz = t3.xyz * t4.xyz;
        t3.xyz = t3.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    } else {
        t11 = min(t2.z, -0.00100000005);
        t11 = -9.99999975e-005 / t11;
        t5.xyz = vec3(t11) * t2.xzw + vec3(0.0, 1.00010002, 0.0);
        t5.w = dot((-t2.xzw), t5.xyz);
        t5.x = dot(_WorldSpaceLightPos0.xyz, t5.xyz);
        t5.xy = (-t5.xw) + vec2(1.0, 1.0);
        t23 = t5.y * 5.25 + -6.80000019;
        t23 = t5.y * t23 + 3.82999992;
        t23 = t5.y * t23 + 0.458999991;
        t14.x = t5.y * t23 + -0.00286999997;
        t14.x = t14.x * 1.44269502;
        t5.y = exp2(t14.x);
        t23 = t5.x * 5.25 + -6.80000019;
        t23 = t5.x * t23 + 3.82999992;
        t23 = t5.x * t23 + 0.458999991;
        t5.x = t5.x * t23 + -0.00286999997;
        t5.xyz = t5.xyy * vec3(1.44269502, 0.25, 0.249900013);
        t5.x = exp2(t5.x);
        t5.x = t5.x * 0.25 + t5.y;
        t14.xz = vec2(t11) * vec2(0.5, 20.0);
        t6.xyz = t2.xzw * t14.xxx;
        t6.xyz = t6.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t11 = dot(t6.xyz, t6.xyz);
        t11 = sqrt(t11);
        t11 = (-t11) + 1.0;
        t11 = t11 * 230.831207;
        t11 = exp2(t11);
        t5.x = t11 * t5.x + (-t5.z);
        t5.x = max(t5.x, 0.0);
        t5.x = min(t5.x, 50.0);
        t6.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t5.xyz = (-t5.xxx) * t6.xyz;
        t5.xyz = t5.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xyz = exp2(t5.xyz);
        t11 = t14.z * t11;
        t5.xyz = vec3(t11) * t3.xyz;
        t6.xyz = t0.xyz * t16_1.xxx + vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t4.xyz = t5.xyz * t6.xyz;
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    //ENDIF
    }
    t16_1.xyz = vec3(_GroundColor.xxyz.y * _GroundColor.xxyz.y, _GroundColor.xxyz.z * _GroundColor.xxyz.z, float(_GroundColor.z) * float(_GroundColor.z));
    t16_1.xyz = t16_1.xyz * t16_3.xyz + t16_4.xyz;
    t16_1.xyz = t16_1.xyz * vec3(_Exposure);
    t16_28 = dot(_WorldSpaceLightPos0.xyz, (-t2.xzw));
    t16_28 = t16_28 * t16_28;
    t16_28 = t16_28 * 0.75 + 0.75;
    t16_7.xyz = vec3(t16_28) * t16_4.xyz;
    t16_7.xyz = t16_7.xyz * vec3(_Exposure);
    t16_8.xyz = t16_3.xyz * _LightColor0.xyz;
    t16_8.xyz = t16_8.xyz * vec3(_Exposure);
    vs_TEXCOORD1.xyz = sqrt(t16_1.xyz);
    vs_TEXCOORD2.xyz = sqrt(t16_7.xyz);
    vs_TEXCOORD3.xyz = sqrt(t16_8.xyz);
    vs_TEXCOORD0.xyz = (-t2.xzw);
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in mediump vec3 vs_TEXCOORD0;
in mediump vec3 vs_TEXCOORD1;
in mediump vec3 vs_TEXCOORD2;
in mediump vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec3 t16_0;
mediump vec3 t16_1;
bool tb2;
mediump vec3 t16_3;
void main()
{
    t16_0.xyz = vs_TEXCOORD0.xyz + _WorldSpaceLightPos0.xyz;
    t16_0.x = dot(t16_0.xyz, t16_0.xyz);
    t16_0.x = sqrt(t16_0.x);
    t16_3.x = float(1.0) / _SunSize;
    t16_0.x = t16_3.x * t16_0.x;
    t16_0.x = clamp(t16_0.x, 0.0, 1.0);
    t16_3.x = t16_0.x * -2.0 + 3.0;
    t16_0.x = t16_0.x * t16_0.x;
    t16_0.x = (-t16_3.x) * t16_0.x + 1.0;
    t16_0.x = t16_0.x * t16_0.x;
    t16_0.x = t16_0.x * 8000.0;
    t16_3.x = vs_TEXCOORD0.y * 50.0;
    t16_3.x = clamp(t16_3.x, 0.0, 1.0);
    t16_1.xyz = vs_TEXCOORD1.xyz + (-vs_TEXCOORD2.xyz);
    t16_3.xyz = t16_3.xxx * t16_1.xyz + vs_TEXCOORD2.xyz;
    t16_1.xyz = t16_0.xxx * vs_TEXCOORD3.xyz + t16_3.xyz;
    tb2 = vs_TEXCOORD0.y<0.0;
    SV_Target0.xyz = (bool(tb2)) ? t16_1.xyz : t16_3.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_HIGH_QUALITY" }
"!!GLES
#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform lowp vec4 _LightColor0;
uniform mediump float _Exposure;
uniform mediump vec3 _GroundColor;
uniform mediump vec3 _SkyTint;
uniform mediump float _AtmosphereThickness;
varying mediump vec3 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 cOut_1;
  mediump vec3 cIn_2;
  highp float far_3;
  highp float kKr4PI_4;
  highp float kKrESun_5;
  highp vec3 kSkyTintInGammaSpace_6;
  highp vec4 tmpvar_7;
  mediump vec3 tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_7 = (glstate_matrix_mvp * _glesVertex);
  kSkyTintInGammaSpace_6 = _SkyTint;
  highp vec3 tmpvar_12;
  tmpvar_12 = (1.0/(pow (mix (vec3(0.5, 0.42, 0.325), vec3(0.8, 0.72, 0.625), 
    (vec3(1.0, 1.0, 1.0) - kSkyTintInGammaSpace_6)
  ), vec3(4.0, 4.0, 4.0))));
  mediump float tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = pow (_AtmosphereThickness, 2.5);
  tmpvar_13 = (0.05 * tmpvar_14);
  kKrESun_5 = tmpvar_13;
  mediump float tmpvar_15;
  tmpvar_15 = (0.03141593 * tmpvar_14);
  kKr4PI_4 = tmpvar_15;
  highp mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_16 * _glesVertex.xyz));
  far_3 = 0.0;
  if ((tmpvar_17.y >= 0.0)) {
    highp vec3 frontColor_18;
    highp vec3 samplePoint_19;
    far_3 = (sqrt((
      (1.050625 + (tmpvar_17.y * tmpvar_17.y))
     - 1.0)) - tmpvar_17.y);
    highp float tmpvar_20;
    tmpvar_20 = (1.0 - (dot (tmpvar_17, vec3(0.0, 1.0001, 0.0)) / 1.0001));
    highp float tmpvar_21;
    tmpvar_21 = (exp((-0.00287 + 
      (tmpvar_20 * (0.459 + (tmpvar_20 * (3.83 + 
        (tmpvar_20 * (-6.8 + (tmpvar_20 * 5.25)))
      ))))
    )) * 0.2460318);
    highp float tmpvar_22;
    tmpvar_22 = (far_3 / 2.0);
    highp float tmpvar_23;
    tmpvar_23 = (tmpvar_22 * 40.00004);
    highp vec3 tmpvar_24;
    tmpvar_24 = (tmpvar_17 * tmpvar_22);
    highp vec3 tmpvar_25;
    tmpvar_25 = (vec3(0.0, 1.0001, 0.0) + (tmpvar_24 * 0.5));
    highp float tmpvar_26;
    tmpvar_26 = sqrt(dot (tmpvar_25, tmpvar_25));
    highp float tmpvar_27;
    tmpvar_27 = exp((160.0002 * (1.0 - tmpvar_26)));
    highp float tmpvar_28;
    tmpvar_28 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, tmpvar_25) / tmpvar_26));
    highp float tmpvar_29;
    tmpvar_29 = (1.0 - (dot (tmpvar_17, tmpvar_25) / tmpvar_26));
    frontColor_18 = (exp((
      -(clamp ((tmpvar_21 + (tmpvar_27 * 
        ((0.25 * exp((-0.00287 + 
          (tmpvar_28 * (0.459 + (tmpvar_28 * (3.83 + 
            (tmpvar_28 * (-6.8 + (tmpvar_28 * 5.25)))
          ))))
        ))) - (0.25 * exp((-0.00287 + 
          (tmpvar_29 * (0.459 + (tmpvar_29 * (3.83 + 
            (tmpvar_29 * (-6.8 + (tmpvar_29 * 5.25)))
          ))))
        ))))
      )), 0.0, 50.0))
     * 
      ((tmpvar_12 * kKr4PI_4) + 0.01256637)
    )) * (tmpvar_27 * tmpvar_23));
    samplePoint_19 = (tmpvar_25 + tmpvar_24);
    highp float tmpvar_30;
    tmpvar_30 = sqrt(dot (samplePoint_19, samplePoint_19));
    highp float tmpvar_31;
    tmpvar_31 = exp((160.0002 * (1.0 - tmpvar_30)));
    highp float tmpvar_32;
    tmpvar_32 = (1.0 - (dot (_WorldSpaceLightPos0.xyz, samplePoint_19) / tmpvar_30));
    highp float tmpvar_33;
    tmpvar_33 = (1.0 - (dot (tmpvar_17, samplePoint_19) / tmpvar_30));
    frontColor_18 = (frontColor_18 + (exp(
      (-(clamp ((tmpvar_21 + 
        (tmpvar_31 * ((0.25 * exp(
          (-0.00287 + (tmpvar_32 * (0.459 + (tmpvar_32 * 
            (3.83 + (tmpvar_32 * (-6.8 + (tmpvar_32 * 5.25))))
          ))))
        )) - (0.25 * exp(
          (-0.00287 + (tmpvar_33 * (0.459 + (tmpvar_33 * 
            (3.83 + (tmpvar_33 * (-6.8 + (tmpvar_33 * 5.25))))
          ))))
        ))))
      ), 0.0, 50.0)) * ((tmpvar_12 * kKr4PI_4) + 0.01256637))
    ) * (tmpvar_31 * tmpvar_23)));
    samplePoint_19 = (samplePoint_19 + tmpvar_24);
    cIn_2 = (frontColor_18 * (tmpvar_12 * kKrESun_5));
    cOut_1 = (frontColor_18 * 0.02);
  } else {
    highp vec3 frontColor_1_34;
    far_3 = (-0.0001 / min (-0.001, tmpvar_17.y));
    highp vec3 tmpvar_35;
    tmpvar_35 = (vec3(0.0, 1.0001, 0.0) + (far_3 * tmpvar_17));
    highp float tmpvar_36;
    highp float tmpvar_37;
    tmpvar_37 = (1.0 - dot (-(tmpvar_17), tmpvar_35));
    tmpvar_36 = (0.25 * exp((-0.00287 + 
      (tmpvar_37 * (0.459 + (tmpvar_37 * (3.83 + 
        (tmpvar_37 * (-6.8 + (tmpvar_37 * 5.25)))
      ))))
    )));
    highp float tmpvar_38;
    tmpvar_38 = (1.0 - dot (_WorldSpaceLightPos0.xyz, tmpvar_35));
    highp float tmpvar_39;
    tmpvar_39 = (far_3 / 2.0);
    highp vec3 tmpvar_40;
    tmpvar_40 = (vec3(0.0, 1.0001, 0.0) + ((tmpvar_17 * tmpvar_39) * 0.5));
    highp float tmpvar_41;
    tmpvar_41 = exp((160.0002 * (1.0 - 
      sqrt(dot (tmpvar_40, tmpvar_40))
    )));
    highp vec3 tmpvar_42;
    tmpvar_42 = exp((-(
      clamp (((tmpvar_41 * (
        (0.25 * exp((-0.00287 + (tmpvar_38 * 
          (0.459 + (tmpvar_38 * (3.83 + (tmpvar_38 * 
            (-6.8 + (tmpvar_38 * 5.25))
          ))))
        ))))
       + tmpvar_36)) - (0.9996001 * tmpvar_36)), 0.0, 50.0)
    ) * (
      (tmpvar_12 * kKr4PI_4)
     + 0.01256637)));
    frontColor_1_34 = (tmpvar_42 * (tmpvar_41 * (tmpvar_39 * 40.00004)));
    cIn_2 = (frontColor_1_34 * ((tmpvar_12 * kKrESun_5) + 0.02));
    highp vec3 tmpvar_43;
    tmpvar_43 = clamp (tmpvar_42, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    cOut_1 = tmpvar_43;
  };
  highp vec3 tmpvar_44;
  tmpvar_44 = -(_glesVertex).xyz;
  tmpvar_8 = tmpvar_44;
  tmpvar_9 = (_Exposure * (cIn_2 + (
    (_GroundColor * _GroundColor)
   * cOut_1)));
  mediump vec3 light_45;
  light_45 = _WorldSpaceLightPos0.xyz;
  mediump vec3 ray_46;
  ray_46 = -(tmpvar_17);
  mediump float tmpvar_47;
  tmpvar_47 = dot (light_45, ray_46);
  tmpvar_10 = (_Exposure * (cIn_2 * (0.75 + 
    (0.75 * (tmpvar_47 * tmpvar_47))
  )));
  tmpvar_11 = (_Exposure * (cOut_1 * _LightColor0.xyz));
  mediump vec3 tmpvar_48;
  tmpvar_48 = sqrt(tmpvar_9);
  tmpvar_9 = tmpvar_48;
  mediump vec3 tmpvar_49;
  tmpvar_49 = sqrt(tmpvar_10);
  tmpvar_10 = tmpvar_49;
  mediump vec3 tmpvar_50;
  tmpvar_50 = sqrt(tmpvar_11);
  tmpvar_11 = tmpvar_50;
  gl_Position = tmpvar_7;
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = tmpvar_48;
  xlv_TEXCOORD2 = tmpvar_49;
  xlv_TEXCOORD3 = tmpvar_50;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform mediump float _SunSize;
varying mediump vec3 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 col_1;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize((tmpvar_2 * xlv_TEXCOORD0));
  mediump float tmpvar_4;
  tmpvar_4 = (tmpvar_3.y / 0.02);
  mediump vec3 tmpvar_5;
  tmpvar_5 = mix (xlv_TEXCOORD2, xlv_TEXCOORD1, vec3(clamp (tmpvar_4, 0.0, 1.0)));
  col_1 = tmpvar_5;
  if ((tmpvar_4 < 0.0)) {
    mediump float eyeCos_6;
    highp float tmpvar_7;
    tmpvar_7 = dot (_WorldSpaceLightPos0.xyz, tmpvar_3);
    eyeCos_6 = tmpvar_7;
    mediump float temp_8;
    temp_8 = ((0.01001645 * (1.0 + 
      (eyeCos_6 * eyeCos_6)
    )) / max (pow (
      (1.9801 - (-1.98 * eyeCos_6))
    , 
      (pow (_SunSize, 0.65) * 10.0)
    ), 0.0001));
    mediump float tmpvar_9;
    tmpvar_9 = pow (temp_8, 0.454545);
    temp_8 = tmpvar_9;
    col_1 = (tmpvar_5 + (tmpvar_9 * xlv_TEXCOORD3));
  };
  mediump vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = col_1;
  gl_FragData[0] = tmpvar_10;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_HIGH_QUALITY" }
"!!GLES3
#ifdef VERTEX
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in highp vec4 in_POSITION0;
out mediump vec3 vs_TEXCOORD0;
out mediump vec3 vs_TEXCOORD1;
out mediump vec3 vs_TEXCOORD2;
out mediump vec3 vs_TEXCOORD3;
highp vec4 t0;
mediump vec3 t16_1;
highp vec4 t2;
highp vec4 t3;
mediump vec3 t16_3;
bool tb3;
highp vec3 t4;
mediump vec3 t16_4;
highp vec4 t5;
highp vec3 t6;
mediump vec3 t16_7;
mediump vec3 t16_8;
highp float t11;
highp float t13;
highp vec3 t14;
highp float t21;
highp float t22;
highp float t23;
highp float t27;
mediump float t16_28;
highp float t30;
highp float t31;
void main()
{
    t0 = in_POSITION0.yyyy * glstate_matrix_mvp[1];
    t0 = glstate_matrix_mvp[0] * in_POSITION0.xxxx + t0;
    t0 = glstate_matrix_mvp[2] * in_POSITION0.zzzz + t0;
    gl_Position = glstate_matrix_mvp[3] * in_POSITION0.wwww + t0;
    t0.xyz = vec3((-_SkyTint.xxyz.y) + float(1.0), (-_SkyTint.xxyz.z) + float(1.0), (-float(_SkyTint.z)) + float(1.0));
    t0.xyz = t0.xyz * vec3(0.300000012, 0.300000042, 0.300000012) + vec3(0.5, 0.419999987, 0.324999988);
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = t0.xyz * t0.xyz;
    t0.xyz = vec3(1.0, 1.0, 1.0) / t0.xyz;
    t16_1.x = log2(_AtmosphereThickness);
    t16_1.x = t16_1.x * 2.5;
    t16_1.x = exp2(t16_1.x);
    t16_1.xy = t16_1.xx * vec2(0.049999997, 0.0314159282);
    t2.xyz = in_POSITION0.yyy * _Object2World[1].xyz;
    t2.xyz = _Object2World[0].xyz * in_POSITION0.xxx + t2.xyz;
    t2.xyz = _Object2World[2].xyz * in_POSITION0.zzz + t2.xyz;
    t27 = dot(t2.xyz, t2.xyz);
    t27 = inversesqrt(t27);
    t2.xzw = vec3(t27) * t2.xyz;
    tb3 = t2.z>=0.0;
    if(tb3){
        t3.x = t2.z * t2.z + 0.0506249666;
        t3.x = sqrt(t3.x);
        t27 = (-t2.y) * t27 + t3.x;
        t11 = (-t2.z) * 1.0 + 1.0;
        t3.x = t11 * 5.25 + -6.80000019;
        t3.x = t11 * t3.x + 3.82999992;
        t3.x = t11 * t3.x + 0.458999991;
        t11 = t11 * t3.x + -0.00286999997;
        t11 = t11 * 1.44269502;
        t11 = exp2(t11);
        t11 = t11 * 0.246031836;
        t3.xy = vec2(t27) * vec2(0.5, 20.0);
        t4.xyz = t2.xzw * t3.xxx;
        t4.xyz = t4.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t27 = dot(t4.xyz, t4.xyz);
        t27 = sqrt(t27);
        t21 = (-t27) + 1.0;
        t21 = t21 * 230.831207;
        t21 = exp2(t21);
        t30 = dot(_WorldSpaceLightPos0.xyz, t4.xyz);
        t30 = t30 / t27;
        t31 = dot(t2.xzw, t4.xyz);
        t27 = t31 / t27;
        t30 = (-t30) + 1.0;
        t31 = t30 * 5.25 + -6.80000019;
        t31 = t30 * t31 + 3.82999992;
        t31 = t30 * t31 + 0.458999991;
        t30 = t30 * t31 + -0.00286999997;
        t30 = t30 * 1.44269502;
        t30 = exp2(t30);
        t27 = (-t27) + 1.0;
        t31 = t27 * 5.25 + -6.80000019;
        t31 = t27 * t31 + 3.82999992;
        t31 = t27 * t31 + 0.458999991;
        t27 = t27 * t31 + -0.00286999997;
        t27 = t27 * 1.44269502;
        t27 = exp2(t27);
        t27 = t27 * 0.25;
        t27 = t30 * 0.25 + (-t27);
        t27 = t21 * t27 + t11;
        t27 = max(t27, 0.0);
        t27 = min(t27, 50.0);
        t5.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t6.xyz = (-vec3(t27)) * t5.xyz;
        t6.xyz = t6.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t6.xyz = exp2(t6.xyz);
        t27 = t3.y * t21;
        t3.xzw = t2.xzw * t3.xxx + t4.xyz;
        t4.x = dot(t3.xzw, t3.xzw);
        t4.x = sqrt(t4.x);
        t13 = (-t4.x) + 1.0;
        t13 = t13 * 230.831207;
        t13 = exp2(t13);
        t22 = dot(_WorldSpaceLightPos0.xyz, t3.xzw);
        t22 = t22 / t4.x;
        t3.x = dot(t2.xzw, t3.xzw);
        t3.x = t3.x / t4.x;
        t21 = (-t22) + 1.0;
        t30 = t21 * 5.25 + -6.80000019;
        t30 = t21 * t30 + 3.82999992;
        t30 = t21 * t30 + 0.458999991;
        t21 = t21 * t30 + -0.00286999997;
        t21 = t21 * 1.44269502;
        t21 = exp2(t21);
        t3.x = (-t3.x) + 1.0;
        t30 = t3.x * 5.25 + -6.80000019;
        t30 = t3.x * t30 + 3.82999992;
        t30 = t3.x * t30 + 0.458999991;
        t3.x = t3.x * t30 + -0.00286999997;
        t3.x = t3.x * 1.44269502;
        t3.x = exp2(t3.x);
        t3.x = t3.x * 0.25;
        t3.x = t21 * 0.25 + (-t3.x);
        t11 = t13 * t3.x + t11;
        t11 = max(t11, 0.0);
        t11 = min(t11, 50.0);
        t3.xzw = t5.xyz * (-vec3(t11));
        t3.xzw = t3.xzw * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xzw = exp2(t3.xzw);
        t11 = t3.y * t13;
        t3.xyz = vec3(t11) * t3.xzw;
        t3.xyz = t6.xyz * vec3(t27) + t3.xyz;
        t4.xyz = t0.xyz * t16_1.xxx;
        t4.xyz = t3.xyz * t4.xyz;
        t3.xyz = t3.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    } else {
        t11 = min(t2.z, -0.00100000005);
        t11 = -9.99999975e-005 / t11;
        t5.xyz = vec3(t11) * t2.xzw + vec3(0.0, 1.00010002, 0.0);
        t5.w = dot((-t2.xzw), t5.xyz);
        t5.x = dot(_WorldSpaceLightPos0.xyz, t5.xyz);
        t5.xy = (-t5.xw) + vec2(1.0, 1.0);
        t23 = t5.y * 5.25 + -6.80000019;
        t23 = t5.y * t23 + 3.82999992;
        t23 = t5.y * t23 + 0.458999991;
        t14.x = t5.y * t23 + -0.00286999997;
        t14.x = t14.x * 1.44269502;
        t5.y = exp2(t14.x);
        t23 = t5.x * 5.25 + -6.80000019;
        t23 = t5.x * t23 + 3.82999992;
        t23 = t5.x * t23 + 0.458999991;
        t5.x = t5.x * t23 + -0.00286999997;
        t5.xyz = t5.xyy * vec3(1.44269502, 0.25, 0.249900013);
        t5.x = exp2(t5.x);
        t5.x = t5.x * 0.25 + t5.y;
        t14.xz = vec2(t11) * vec2(0.5, 20.0);
        t6.xyz = t2.xzw * t14.xxx;
        t6.xyz = t6.xyz * vec3(0.5, 0.5, 0.5) + vec3(0.0, 1.00010002, 0.0);
        t11 = dot(t6.xyz, t6.xyz);
        t11 = sqrt(t11);
        t11 = (-t11) + 1.0;
        t11 = t11 * 230.831207;
        t11 = exp2(t11);
        t5.x = t11 * t5.x + (-t5.z);
        t5.x = max(t5.x, 0.0);
        t5.x = min(t5.x, 50.0);
        t6.xyz = t0.xyz * t16_1.yyy + vec3(0.0125663709, 0.0125663709, 0.0125663709);
        t5.xyz = (-t5.xxx) * t6.xyz;
        t5.xyz = t5.xyz * vec3(1.44269502, 1.44269502, 1.44269502);
        t3.xyz = exp2(t5.xyz);
        t11 = t14.z * t11;
        t5.xyz = vec3(t11) * t3.xyz;
        t6.xyz = t0.xyz * t16_1.xxx + vec3(0.0199999996, 0.0199999996, 0.0199999996);
        t4.xyz = t5.xyz * t6.xyz;
        t16_4.xyz = t4.xyz;
        t16_3.xyz = t3.xyz;
    //ENDIF
    }
    t16_1.xyz = vec3(_GroundColor.xxyz.y * _GroundColor.xxyz.y, _GroundColor.xxyz.z * _GroundColor.xxyz.z, float(_GroundColor.z) * float(_GroundColor.z));
    t16_1.xyz = t16_1.xyz * t16_3.xyz + t16_4.xyz;
    t16_1.xyz = t16_1.xyz * vec3(_Exposure);
    t16_28 = dot(_WorldSpaceLightPos0.xyz, (-t2.xzw));
    t16_28 = t16_28 * t16_28;
    t16_28 = t16_28 * 0.75 + 0.75;
    t16_7.xyz = vec3(t16_28) * t16_4.xyz;
    t16_7.xyz = t16_7.xyz * vec3(_Exposure);
    t16_8.xyz = t16_3.xyz * _LightColor0.xyz;
    t16_8.xyz = t16_8.xyz * vec3(_Exposure);
    vs_TEXCOORD1.xyz = sqrt(t16_1.xyz);
    vs_TEXCOORD2.xyz = sqrt(t16_7.xyz);
    vs_TEXCOORD3.xyz = sqrt(t16_8.xyz);
    vs_TEXCOORD0.xyz = (-in_POSITION0.xyz);
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	vec4 unity_WorldTransformParams;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	lowp vec4 _LightColor0;
uniform 	lowp vec4 _SpecColor;
uniform 	mediump vec4 unity_LightGammaCorrectionConsts;
uniform 	mediump float _Exposure;
uniform 	mediump vec3 _GroundColor;
uniform 	mediump float _SunSize;
uniform 	mediump vec3 _SkyTint;
uniform 	mediump float _AtmosphereThickness;
in mediump vec3 vs_TEXCOORD0;
in mediump vec3 vs_TEXCOORD1;
in mediump vec3 vs_TEXCOORD2;
in mediump vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec3 t16_0;
highp vec3 t1;
bool tb1;
mediump vec3 t16_2;
mediump vec3 t16_3;
highp float t10;
void main()
{
    t16_0.x = log2(_SunSize);
    t16_0.x = t16_0.x * 0.649999976;
    t16_0.x = exp2(t16_0.x);
    t1.xyz = vs_TEXCOORD0.yyy * _Object2World[1].xyz;
    t1.xyz = _Object2World[0].xyz * vs_TEXCOORD0.xxx + t1.xyz;
    t1.xyz = _Object2World[2].xyz * vs_TEXCOORD0.zzz + t1.xyz;
    t10 = dot(t1.xyz, t1.xyz);
    t10 = inversesqrt(t10);
    t1.xyz = vec3(t10) * t1.xyz;
    t1.x = dot(_WorldSpaceLightPos0.xyz, t1.xyz);
    t16_3.x = (-t1.x) * -1.98000002 + 1.98010004;
    t16_0.z = t1.x * t1.x + 1.0;
    t16_0.xz = t16_0.xz * vec2(10.0, 0.0100164423);
    t16_3.x = log2(t16_3.x);
    t16_0.x = t16_3.x * t16_0.x;
    t16_0.x = exp2(t16_0.x);
    t16_0.x = max(t16_0.x, 9.99999975e-005);
    t16_0.x = t16_0.z / t16_0.x;
    t16_0.x = log2(t16_0.x);
    t16_0.x = t16_0.x * 0.454544991;
    t16_0.x = exp2(t16_0.x);
    t16_3.x = t1.y * 50.0;
    t16_3.x = clamp(t16_3.x, 0.0, 1.0);
    tb1 = t1.y<0.0;
    t16_2.xyz = vs_TEXCOORD1.xyz + (-vs_TEXCOORD2.xyz);
    t16_3.xyz = t16_3.xxx * t16_2.xyz + vs_TEXCOORD2.xyz;
    t16_2.xyz = t16_0.xxx * vs_TEXCOORD3.xyz + t16_3.xyz;
    SV_Target0.xyz = (bool(tb1)) ? t16_2.xyz : t16_3.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "_SUNDISK_NONE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "_SUNDISK_NONE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "_SUNDISK_SIMPLE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "_SUNDISK_SIMPLE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "_SUNDISK_HIGH_QUALITY" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "_SUNDISK_HIGH_QUALITY" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_NONE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_NONE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_SIMPLE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_SIMPLE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_HIGH_QUALITY" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "UNITY_COLORSPACE_GAMMA" "_SUNDISK_HIGH_QUALITY" }
"!!GLES3"
}
}
 }
}
Fallback Off
}