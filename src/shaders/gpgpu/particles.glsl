// We are going to handle the flow field here
uniform float uTime;
uniform sampler2D uBase;

#include ../includes/simplexNoise4d.glsl

void main() {
    float time = uTime * 0.2;
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 particle = texture(uParticles, uv); // we already have access to uParticles without importing the uniform
    vec4 base = texture(uBase, uv);

    if (particle.a >= 1.0) {
        particle.a = 0.0; // if it's more than 1.0 then the particle is dead
        particle.xyz = base.xyz;
    } else {
        // Flow field (alive particles)
        vec3 flowField = vec3(
            simplexNoise4d(vec4(particle.xyz + 0.0, uTime)), // x
            simplexNoise4d(vec4(particle.xyz + 1.0, uTime)), // y
            simplexNoise4d(vec4(particle.xyz + 2.0, uTime)) // z
        ); // the direction towards which the particles should move
        flowField = normalize(flowField); // being a direction, directions need to be normalized
        particle.xyz += flowField * 0.01; // we "nerf" the flow field by multiplying it

        // Decay
        particle.a += 0.01;
    }

    gl_FragColor = particle;
}