// We are going to handle the flow field here
uniform float uTime;

#include ../includes/simplexNoise4d.glsl

void main() {
    float time = uTime * 0.2;
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 particle = texture(uParticles, uv); // we already have access to uParticles without importing the uniform
    
    // Flow field
    vec3 flowField = vec3(
        simplexNoise4d(vec4(particle.xyz + 0.0, uTime)), // x
        simplexNoise4d(vec4(particle.xyz + 1.0, uTime)), // y
        simplexNoise4d(vec4(particle.xyz + 2.0, uTime)) // z
    ); // the direction towards which the particles should move
    flowField = normalize(flowField); // being a direction, directions need to be normalized
    particle.xyz += flowField * 0.01; // we "nerf" the flow field by multiplying it

    gl_FragColor = particle;
}