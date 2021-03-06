uniform mat4 uMVPMatrix;
uniform mat4 uMMatrix;
uniform vec3 uCamera;
uniform vec3 uLightLocationSun;

attribute vec3 aPosition;
attribute vec2 aTexCoor;
attribute vec3 aNormal;

varying vec4 vDiffuse;
varying vec4 vAmbient;
varying vec4 vSpecular;
varying vec2 vTextureCoor;

void pointLight(
     in vec3 normal,
     inout vec4 ambient,
     inout vec4 diffuse,
     inout vec4 specular,
     in vec3 lightLocation,
     in vec4 lightAmbient,
     in vec4 lightDiffuse,
     in vec4 lightSpecular
     ) {
        ambient = lightAmbient;
        vec3 normalTarget = aPosition + normal;
        vec3 newNormal = (uMMatrix * vec4(normalTarget, 1)).xyz - (uMMatrix * vec4(aPosition, 1)).xyz;
        newNormal = normalize(newNormal);

        vec3 eye = normalize(uCamera - (uMMatrix * vec4(aPosition, 1)).xyz);
        vec3 vp = normalize(lightLocation - (uMMatrix * vec4(aPosition, 1.0)).xyz);
        vp = normalize(vp);

        vec3 halfVector = normalize(vp + eye);

        float shininess = 50.0f;
        float nDotViewPositon = max(0.0, dot(newNormal, vp));
        diffuse = lightDiffuse * nDotViewPositon;

        float nDotViewHalfVector = dot(newNormal, halfVector);
        float powerFactor = max(0.0, pow(nDotViewHalfVector, shininess));
        specular = lightSpecular * powerFactor;
     }


void main() {
    vec4 diffuseTmp = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 ambientTmp = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 specularTmp = vec4(0.0, 0.0, 0.0, 0.0);

    pointLight(normalize(aNormal), ambientTmp, diffuseTmp, specularTmp, uLightLocationSun, vec4(0.05, 0.05, 0.05, 1.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(0.3, 0.3, 0.3, 1.0));
    //pointLight(normalize(aNormal), ambientTmp, diffuseTmp, specularTmp, uLightLocationSun, vec4(1.0, 1.0, 0.5, 1.0), vec4(1.0, 1.0, 0.5, 1.0), vec4(1.0, 1.0, 0.5, 1.0));

    vAmbient = ambientTmp;
    vSpecular = specularTmp;
    vDiffuse = diffuseTmp;

    vTextureCoor = aTexCoor;

    gl_Position = uMVPMatrix * vec4(aPosition, 1);
}