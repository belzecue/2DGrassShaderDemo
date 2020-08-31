GDPC                                                                            %   @   res://.import/clouds.png-2d66d2275e786b0be590e20d83aa6916.stex  �            ��*Lh�
yl� X�V@   res://.import/gradient.png-6b444d13f43f452b4947f50846516ae6.stex�-      x       8�:���v���z6�S<   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex      �      T�[~.��e��y��d�@   res://.import/noise.png-bb7ee9b1cae22f59aa9c7a55a764cfa3.stex   �0      �      	*�����8�&�P�D   res://.import/scarecrow1.png-dae8ec9afd517e0e73d9a4eb7f1bc7fd.stex  @�      �      ቱPRm�2Ͻ���QD   res://.import/scarecrow2.png-f3227a783f1689950de27abf7af96936.stex  ��      �      "�Pg3����Ĥ}�D   res://.import/scarecrow3.png-227191083539891c0ab73410a1ed2e9f.stex  ��      �      � ���k�{\ +�˱e @   res://.import/stone.png-005a59f14bd4c49707ae6ded67307167.stex   �            �L��I����_�_`@   res://.import/texture.png-59546a6b6ae00ae598d09228d4c66fd2.stex ��      �      ��������FD�ٗ�D   res://.import/worley_noise.png-dca0570437ce198350d2a0c542f4796d.stex      �       ��E��ê��@���n+n$   res://assets/materials/cover.tres   �            È1n�x:�Nb�d�w$   res://assets/shaders/cover.shader   �      �      �7�[���b��}-�i$   res://assets/shaders/grass.shader   �      D      ���n����C5@��-�(   res://assets/textures/clouds.png.import �*      �      �F�����ם��Tf�,   res://assets/textures/gradient.png.import    .      �      �;NX���T�HE�(   res://assets/textures/noise.png.import  ��      �      T� �,�����9V�<},   res://assets/textures/scarecrow1.png.import 0�      �      �z7����[eC�,   res://assets/textures/scarecrow2.png.import ��      �      �ʠ\i������q���,   res://assets/textures/scarecrow3.png.import `�      �      5C|�z��J}�w���(   res://assets/textures/stone.png.import   �      �      ��z��X��-GĈ(   res://assets/textures/texture.png.importp�      �      ���}42�K�ss0   res://assets/textures/worley_noise.png.import   �      �      ޣ��./� ��0֧   res://default_env.tres  p     �       um�`�N��<*ỳ�8   res://icon.png  �A     �      $Uʥ��ֶ�����n�   res://icon.png.import    !     �      �����%��(#AB�   res://project.binary�^     �      �����)i�4P��    res://scene/CloudRect.gd.remap   A     *       �Y�G�o&bkޣ�(}'   res://scene/CloudRect.gdc   �#     �       ���f�L4�[�|�J   res://scene/Clouds.gd.remap 0A     '       �pb8�]%�] <I�K�   res://scene/Clouds.gdc  P$     �       Cw�4��+�ƁA�p�   res://scene/Grass.gd.remap  `A     &       ��e4�@n/GG   res://scene/Grass.gdc   %     �       &q=���!�`���   res://scene/Light2D.gd.remap�A     (       Gs=��B�a婹�g�   res://scene/Light2D.gdc �%           ~l�� ��;.�:23   res://scene/Main.tscn   �&     ,      ?����j��u2�dW5$   res://scripts/GrassPatch.gd.remap   �A     -       kHŰ
���{�s\�ܯ   res://scripts/GrassPatch.gdc <     �      >5
x�-ha�����        [gd_resource type="ShaderMaterial" load_steps=4 format=2]

[ext_resource path="res://assets/shaders/cover.shader" type="Shader" id=1]
[ext_resource path="res://assets/textures/worley_noise.png" type="Texture" id=2]

[sub_resource type="ViewportTexture" id=1]
viewport_path = NodePath("Grass")

[resource]
resource_local_to_scene = true
shader = ExtResource( 1 )
shader_param/noise_tex_size = Vector2( 50, 1 )
shader_param/wind_speed = 1.0
shader_param/grass_tex = SubResource( 1 )
shader_param/noise_tex = ExtResource( 2 )
     shader_type canvas_item;

uniform sampler2D grass_tex;
uniform sampler2D noise_tex;
uniform vec2 noise_tex_size;
uniform float wind_speed;

const float MAX_BLADE_LENGTH = 10.0f;

float sampleNoise(vec2 uv, vec2 texture_pixel_size, float offset) {
	return texture(noise_tex, vec2(uv.x / texture_pixel_size.x / noise_tex_size.x + offset, 0.0f)).r;
}

void fragment() {
	// First, color the sprite normally
	COLOR = texture(TEXTURE, UV);
	
	// Sample some noise
	float noise = sampleNoise(SCREEN_UV, SCREEN_PIXEL_SIZE, 0.1f*TIME);
	
	// Determine how "high" we are in pixels
	float height = (1.0f - UV.y) / TEXTURE_PIXEL_SIZE.y;
	
	// Determine screen uv at the bottom of the sprite
	vec2 uv = SCREEN_UV - vec2(0.0f, height * SCREEN_PIXEL_SIZE.y);
	
	// We need to look for blades below the sprite until we reach the max blade length
	for (float i = 0.0f; i < MAX_BLADE_LENGTH; ++i) {
		// Sample the blade length
		float blade_length = texture(grass_tex, uv).r * 255.0f;
		blade_length += noise; // and add some noise
		
		// The current pixel is below the blade tip, do not draw it
		if (height <= blade_length) {
			COLOR=vec4(0.0f, 0.0f, 0.0f, 0.0f);
		}
		
		// Move down to the next pixel
		uv.y -= SCREEN_PIXEL_SIZE.y;
		height += 1.0f;
	}
}   shader_type canvas_item;

uniform float wind_speed;
uniform vec2 wind_direction;
uniform vec4 tip_color : hint_color;
uniform vec4 wind_color : hint_color;
uniform sampler2D gradient;
uniform sampler2D tex;
uniform sampler2D noise_tex;
uniform vec2 noise_tex_size;
uniform sampler2D cloud_tex;

const float MAX_BLADE_LENGTH = 10.0f;
const float PI = 3.1415926535;

// Simple sine wave with period T, amplitude a, phase and direction
float sineWave(float T, float a, float phase, vec2 dir, vec2 pos) {
	return a * sin(2.0f * PI / T * dot(dir, pos) + phase);
}

vec4 sampleColor(float dist) {
	return texture(gradient, vec2(dist + 0.5f, 0.0f) / 3.0f);
}

float sampleBladeLength(vec2 uv) {
	return texture(tex, uv).r * 255.0f;
}

float sampleNoise(vec2 uv, vec2 texture_pixel_size, float offset) {
	return texture(noise_tex, vec2(uv.x / texture_pixel_size.x / noise_tex_size.x + offset, 0.0f)).r;
}

float wind (vec2 pos, float t) {
	return (sineWave(200.0f, 1.8f, 1.0f*wind_speed*t, normalize(wind_direction), pos)
		   + sineWave(70.0f, 0.1f, 2.0f*wind_speed*t, normalize(wind_direction - vec2(0.0f, 0.4f)), pos)
		   + sineWave(75.0f, 0.1f, 1.5f*wind_speed*t, normalize(wind_direction + vec2(0.4f, 0.0f)), pos))
		   / 3.0f;
}

void fragment() {
	// First, sample some 1D noise
	float noise = sampleNoise(UV, SCREEN_PIXEL_SIZE, 0.1f * wind_speed * TIME);
	// Add the nose to the uv for frayed grass
	vec2 uv = SCREEN_UV - vec2(0.0f, SCREEN_PIXEL_SIZE.y * noise);
	// We also need the screen uv later since clouds are sampled from it
	vec2 screen_uv = SCREEN_UV - vec2(0.0f, SCREEN_PIXEL_SIZE.y * noise);

	// Color the base of the grass with the first gradient color
	if (texture(tex, SCREEN_UV).r > 0.0f) {
		COLOR = sampleColor(0.0f);
		COLOR -= vec4(vec3(texture(cloud_tex, SCREEN_UV).r), 0.0f);
	} else {
		COLOR = vec4(0.0f, 0.0f, 0.0f, 0.0f);
	}
	
	for (float dist = 0.0f; dist < MAX_BLADE_LENGTH; ++dist) {
		// Sample the wind
		float wind = wind(uv / SCREEN_PIXEL_SIZE, TIME);
		
		// Get the height of the balde originating at the current pixel
		// (0 means no blade)
		float blade_length = sampleBladeLength(uv);
		
		if (blade_length > 0.0f) {
			// Blades are pressed down by the wind
			if (wind > 0.5f) {
				blade_length -= 1.0f;
			}
			
			// Color basec on distance from root
			if (dist == blade_length) {
				// Color grass tips
				if (wind <= 0.5f) {
					COLOR = tip_color;
				} else {
					COLOR = wind_color;
				}
				
				// Add the cloud shadow
				COLOR -= vec4(vec3(texture(cloud_tex, screen_uv).r), 0.0f);
			} else if (dist < blade_length) {
				// Color grass stems
				COLOR = sampleColor(dist);
				
				// Add the cloud shadow
				COLOR -= vec4(vec3(texture(cloud_tex, screen_uv).r), 0.0f);
			}
		}
		
		// Move on to the next pixel, down the blades
		uv -= vec2(0.0f, SCREEN_PIXEL_SIZE.y);
		screen_uv -= vec2(0.0f, SCREEN_PIXEL_SIZE.y);
	}
}            GDST�  h          �  PNG �PNG

   IHDR  �  h   HP�   sRGB ���  �IDATx���Ar�6@QNʇ��O��d����-�"@7��25�)��/H4�m                                                     �R��>  R��n���~oz$�` ~v<��d� �s�}$ÿ` �w=��d�`ۢ��I��`��5J�'�� ,�u}w�� ,�Oz?i������i�F  ��/_��el}m�?�,��7;`�U$��M��c� �C���p��K4�`~��{��sߒZ��*�/|�r�[R0��Է�l`��	�<`����wI,� 3�g�gX������aw�`]��0 K�``uC,� 0��.�*��I3�z?�?a���R)���z�r � ��m��iH%����a��\�����<�m��b��K�+�������(�e�8!4`��])5`.�u#5f�O2����Q�:��t��&8-�?bГ 祈@����:�!2���UyN��� '5jT:7��Ôa����uXy������Zp�_�y:�� ����p�9JE��*�}?��L��T�؄�`u�qyNK����g�����_C����� G��&af.>%�}D��pB%�nˋ w5������`	�@�g3�y��	���0�k�����c��>���? �+���;q�N��8��F�p[ӷg����LL�Z$��"?��&8ne��,�`B014��	NB��X�Fk>j�H�3`"i0T���	p<J���`�@!<� S������Fi&�M0�#���0�x�u�hE����j�mm���mX͚s����f�/AS��/�BϵE��G}��֎ �s�6��4�yy`*Q_�o����0��E����T�F�,/L��=����n���Q�~�"pMۇ:�"9py�2�^�I/���u�Qω#�O����s�r���}�!�d�F�{���2Lp��5�ٰ�\$�,8܉��g$�#N�i��<j�,��p?�B��>\���E��J"�����j���Ų��h_Y!�-#<�Qnr�v�]!�. <�oe�h���Xz��4����V� 0� �  0�yX� � ���b��m�5�� v��,�	���e ���&��X�0 `��"�`�_`qv��(�
쀓�{�I� �5k��`���k�����i2�� �\�U@�n]<�$� 	;�2��y�0��;�dH����#�^�g���~]�#� �	p=�,� �pI�,� �	pa-2,� }pyQ�^��x�3��                                                                                                                               0�?� X��v������G0�ܳ�>�aV#�@CG��H�Y� ��[ߝ��8Wߝ��]��N��� ���w���M��HQ��i0�g� ��쀁0��ߝM0���쀁-��;�`�d 0  � 0��� �x���7M!?�b�\�������Ё����.t�{]o`����]��^��0��Å����ǹ
��ڋ/r�����
�!��.���iHp�0�����[סּ��/�g��enI5�Yvذ��S}�� ÊZ��}1���
\���b��o�F]�e�X� ���m� P� o6_�C��c� �i�����m�B�L�ݐ7w��DZ���p�̶��Vp�[��9|�w�(a� G�q��pE�Ő���U�`w�%�9��9�Q�7‌f���v��|��w��I%,����$7kڍ�w�(�ҙ��[�\O��'��	`eӟH�`�#d� ��"K��v{���E~2,e�0�Tc�?�n�p}����#�s��s�߯�`dn�]�sb��_�<u���%�����<�0��f^�/����$.�xi�+t/Ŵ��a�Z�j- ��pŞU<f b�pݒ�=r Bp��U?~ �(�	h0���X� (�j�����r݊���E07Lk�oġ��Q_�)H�T����E�I}�`L�����K}��-XP� �/���v�X�Z׋����� ����'���[\���]4�)��`���VZV0Z�`�.��iY��V�������j~�S� �.�NZF�(mw�����xd���5�+�	�]�0G	�SB�
�U�4��w*CJ�&�X\d���X�bH��U�Yj��)���b�)��pR�\v��Up�-�@�����.�	 s` @�S�Z�_}r~A\'� gh0	0�ce��o�+�<�4�D�9'8��
 G�\e�	��	�_��	�]Ml ��C:���
��K1 �0dd�`  >�^d�2�}��0��0�� �����9`^v���Ô8)k.��0�4&#�Yj���~wn�4��~9a]g�������]����az<U�*�t"�E^N` @����2��#� �/�	p
f*2�\!��a���rQ��o�"�Mf��3��uv�#�a���">�N̓���t�r�ǰ\B]^�'D�{�;'�3�K;���u܏���׍��V�,*=�>�55��B`>e���ÀsQۋ��=A}p:c�8����Y��n�'�V1R92}�'�R�z�a�ޖlIN����Ȩ�0�\�)���m���s��sQ�q�}����X�3��z'�Yg{��@;�^��4�k\��|&�>���L'�L�>9���;�O��e[��^�	m�
�u#�+7��u��>,��q��Ne�� ���.�m�eY�sQ�x�8�o�g�`��o�DI�˨x� ?��(W����nx�����y����l�L�S(�?�:~k�2x�xcen��~���%�4�f��l���r�VZ����10.d�w��ܷ���H� �Q��B��_�z�[[Rh�F��<B��|��G���Қ g��.u"Á]|�ݥ�>8/�vr3��LF���G                                              ~�/��!�5`�    IEND�B`�             [remap]

importer="texture"
type="StreamTexture"
path="res://.import/clouds.png-2d66d2275e786b0be590e20d83aa6916.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/clouds.png"
dest_files=[ "res://.import/clouds.png-2d66d2275e786b0be590e20d83aa6916.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=1
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
         GDST               \   PNG �PNG

   IHDR         ����   sRGB ���   IDAT�c��R�W 
���5�;    IEND�B`�        [remap]

importer="texture"
type="StreamTexture"
path="res://.import/gradient.png-6b444d13f43f452b4947f50846516ae6.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/gradient.png"
dest_files=[ "res://.import/gradient.png-6b444d13f43f452b4947f50846516ae6.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
   GDST�   �           ՛  PNG �PNG

   IHDR   �   �   �>a�   sRGB ���    IDATx�d�ytU�y�ߙu����@B�@hfb00$6�Wb7��6iڕv�]��������V�դ�&1؀����$�$!	��y<�y�:{nYk�%4�������>��~�����t�R ���"����[�avv���>�͛��V�ttt�t�R,X�ŋ)..fvv��>�@mڴI.]��֮]˽{� d���<|����n|>�1���o~#�2�L�;w�H~~>��� �h4��`������~zzz Taa�ܸq�5k���_����^x��v;O�>P���ȍ7�z� *55U u��U)**���Ǥ��c6������t(��lܸ���A��� ��Ȉ��� jzzZjkk)))����o�۴���`�.]�DUU��� jvv�� �Զm�P2==Maa������ �����`@EEE	�>��STll��~WݼySRSS�Z� ���W��� ������������ĉ,Z���?511!�|���Ȑ@  ��7X�b����a ���)7o�$�(LMM�t:������RSS����������4���ٶm���/Pn�[���Ucc�<}����|��zeٲeLOO311AJJ
�����vQ}}}b0(//����ۭ?����ܽ{W͟?@����f���f�.]*�2�����S��ӕ��6���1�r��u544$���l��@]�~]�^���f���Cww�*,,���A���8z�(			*&&F��d���LNN��_ȂTvv6�o�f||\�� ��������R�ӟ����{O�|>����/�����R������,[��k׮&]]]�������ݻw%##C����رc ���`�X�������z&&&$99���H��른��`0����ҭnffF����x�"�t:Y�d	/^$""BrrrHKK������L ����u����Y�r%?������YV�Z��А�ϟ��Ç������$�~�8v오�����J  <<\ ���-ccc|��W��o0<<,����566&���x�^	czz�����KDD�0::���s����zپ};��ê�� ��'SSSDFF���d���$������%K�H �b��W^^.ǎ�f�I ���Z���dY�b��������իWy��W���1���k�x���{�ILL�LOO��� ��������l��fB΅f�ښ,[�L�޽�=z$�/V�����%&&
���� /�����z��ۉ��@��~��O~Byy��B	F���ȁ0�L���RRR����СC���h!�ŋGUU^��/�����l����-�ݺu��K�GNN��� ����+W�Ȯ]�4`vv�]�vIff��|>=�k��j%33S�.]Jdd$���z��墺���˗�o}��Ǻu먬������x<Z�c���455IVVw����URRB}}�s�~�����ի��RSSijj�����ng�ʕ?~������Ν;1�������_R__������۷o�_{�^�^/6��K�.�=��ݻq�\�W_}@%$$Ț5kd޼ydff������|��������&%%�M�6���'�֭c���#]]] ����9r�7oޤ���r>n�������1��$&&�����fTVV�a �ѣG���288(555��~Ο?Off&.����	g�ʕ444�l�2��o~��d�d2�9=2>>�ƍ壏>���8�ꫯY9�PO(-�y�����###;v���Q��� ���nܸ!K�,!::�

��lb0��Ç��Jbb�$$$�v���ի����s��1;;K  22R�(���4���x<V�\	 ���u�Vq:���~��������� F�Q~��������������Β��.�ϟ��Jkk� �j�*�x��bddD���h4�t:IJJ��͛�ٳ-J��������~���l=
LOOKxx8^����T�<y���,w��!�p8PJ����>����YZ[[y�䉔����je�֭���F#o��ׯ_׿W]]Mtt4f����p:::���L&��<��U\\Lgg'"���8_�5~����N��O(//�@�jnn�b��r�0�����/�AD���P�C�aaa��Ʋr�Jٳg���/�ꫯ�h4�͙��m�����ill$""B���J}��`P��J�$��M{{;6���7�v���~@JJ
���ǚ5kX�f�`�������ŋ���֍�ĉ���+������{��f^{�56�@Y,���ٿ?>��?�PN�8Agg'�E|>׮]�WJq����L&��Ӊ��f����:�N���X�f���(m�m67oޔ�Ǐ���p�.]Joo�DGG322"Zț��P���/�׿�5111:t���^n߾Moo/����k ,22��;w����{�ǢE����������4fff�Z�b2��M���R=*<~������0W%���hll��v���IEE���$''#"ܺu�[�nQZZ*�{_�x��#aaa���F��/�B_���LQJ���'�N���}��i6o������h"##Y�r% j||�����󥢢���*bcc��p�����d"""B u��A�-22�χ�`@)œ'O�0��JO�<A+�ZZZ���<x����)�y�<z�������������z���� ���Kkk�466211����|��ݍ���Tyyy��|���2q�\��_��JOOG)%��������zell���A�;Ʊc�hii��ӧdgg3;;��``Ϟ=8�Ny6�j߾}������/^���d&''5�WW�\�`0HCC��ͣ����7255��n�j�b�Z9w.����>����������~�f?~L}}�,Y�DN�8�?������|R]]-'N���#III�E�`0(����6Ժu����@MNN������1������1i�.ʛo���̌���ra�Z	*))I�F�tttPYYIbb�LOO���zY�n��\. ���+���x<�f�Z�p����f���"??���D&&&�$''���@jj��l6���Kqq1���������1���+����߿��[���f���s��5֮]+/^d�Ν\�rE��ʰ�l$$$���#�����Lnn."�o�3^GXX����LOO���y�����$V��U�V��۫�����
�GG���7o�Jx���ܼy��^zI��dddp��}UWW�U$$$p��i�.]��˗���S###���&&��;w���,K�,��� ��$^����\>|��f�8��� (Ö-[8uꔈ�F.\� ---�v��v��V�^MFF:t���Y�����㔔��h�b�P]]�ʕ+u�Z5;;+UUU��ֲh�"fff���cٲe���a4%>>^`��x
���8�<���ja�o��a4ԁسg���JO �.]�������t:	�h^s��N�<���@rrrDD�ƍ�\.�F#ׯ_'!!���26oެy���:Y��ᐓ'O
 k׮�b��Vz��U#�8z�(�6mb``@4>f˖- �f�=: *55���T����ڵk�?������� ����l���*���F�))),]�T��-[�`��Pk֬���l6b�xY����$TSS}��,X�@�CCC�r�x��� b2��X+��X,?~�U�B��j���lڴ���l��������Sm���ٳ������a�Zq�\�]�VRRR0�L\�vMC����S ��/�p8x��״�Q�^��`0H0���@/��F#����n��o}�y��a0䷿��<�nb�X�h4�ŋE)�WQ[�l���a���9v�������p8��������� ,Y���DEE�֭�n��f�


�w����h�"�������r��>��#q:�h8�l6��b�`08�<�z��!����p�B*++u�R^^.555|��gr��ez{{Y�f�444�a�	�~��|�ڵ��������f������*���������������D�������U�V��;�@Yv����a��� �p���t�nff��7�����0o�<8�����vc������|�r@�XUQQF����J�x��믿֑x~~��\.�����Ǐ�~�z�f�|�������~?O�<�l6���������B�ݻ'���:G�E$���JJJ��166��3o�<q�\�Z����
4�ٳgihh`���z�B�j������餲�R�RPǎc߾}�˗/c��|������#���@C�f����V|>SSSDDD0::ʆ�
�6���$$$�m�6�ݻ��/�L{{��	_}�===x�^ݳΟ?O^^7o�����N#U$r��q9w��s--\�|���),�s�����	��ܹ�?��?p��i���DFF�z�233���0Wni�������pbbbЀ�����;(�())�?��?�h����/�K�=�%�-qoܸ!������'F�QB��W:w����n����0�v;/��999��~������R��K�.	 ۶m���@%%%a��0����`2���ϗ�;wJaa!W�^����ҥK���'55���a���������(�,Y����!rrrdӦM�^����:�f��Ǐ���P������g��fff��@cbb�x<!**J:;;���d���l߾���fgg)++����X,��'?�����9x�8p���Ν;���`˖-2==ͪU��R�4������x�?��200 LLL����`0�d�V�X��{���� �Bcccb4�z���?� ���便����

����ĉ��7��M�F#			�N����d�������RN�<����h���������*�Ҧ��.���!��������Ǐ���AK�@���r���0TUU�ս!Μ�'O�8p�C��������5.��CXX����Ξ=+�֭cѢE���떯-\{{;�ׯ���v����J�u���ƴd��~?���3<<���4���^y�~����o[ ���.��f�Y'�y뭷t����A먽���ETTw�����������X�V����˗���$%%���$Y�x1�����^�p���
N�8��͛y���1�455���CRRR��ٳz9���=J�l6�^�J0�P�;{۷o'))I'�,���~innfӦM��̐�������������%K�R�m�p�\ܹs��������ٳ4�������;v�`ٲe�E�ɋ/�ȋ/�HBBZ�455��e;w����233��ࠬZ������|�\.����Y�l��h�811�F���s��)V�X!�`P�R��撞�Nzz:>�OG�zM����ʣ z�A����T���hƨE��âE�8�<�V�b��ݲo�> ���S}��К��H�k��˗�VFk�I��Y�f��.�c�`�Df�%,��k��l�2��7��������_|!/��2"�W:���J��111������� ��foo�����<~�X<����a��������,'N�@Dcjj�;v�9���˜:u������ӧO)//���X�V�9}���>|Xﭧ���U�AZ[[�����KMM˖-ӽ�h4���رc��w������ӭ<''G ٲe� \�p��g�r��=/^���G�����������0"##�������c2�tc������������|�M����{����-����2�6mB3���L&999211����X,���b�X��|���p��=��$�����}���b%11���"=�ܹs���������l�Yrrr����LNN��>�jv��- =z���
<��� ���,�����������immell�/��Rl,[����A�N''N���Ǐ��_222����q8�x�b***���!--���q|>������#��Φ���_��W0��������[��#�v�����ٌ���Ԕ �^/���|��Wtuu1;;ˏ~�#�K#)�߿_N�:�����Vinn����}��q��U����?�l6222dhh��Cff&'N���r�+H{{;UUU���̕����J0�����!�v�b׮]�������ٳg�?1�>��χ��d���l۶Mge-���ρ���z���)**ҫ�V�^MSS����Hxx8!�Ug��K/�9��۷ٻw/���h��x`ӦM���i�Mjj*�ر�W_}��۷�a�8 ! �ݬ������
��/��ɡC��u�����f��&.���������f���9r�������_�-�������ݻW�Wll�n�����09u����,_����2�|�M�p����X�V>��3������������=ٱcn����*~���s��b������7�ܿ@����ŏ?����x���0z��	?/��IIIRWW��v�9�FMOMM���Ǚ��fzz���4��|���PSS#�\�|YD�'O�ȧ�~����Y�jv����xټy3֋�����Q�~?b�����4��CTT����B�;��&&&t�PjllD�C{<dttT�n�^\�p��RSSCSS�s!�f�!"���t��k���իW����ɓ'p��Mn߾-���TVV233#�n�ҥK����b��IKK��WW�^����IJJ�گ�?�?������B-aaa���[:h��o�F��������^�������G^^�LNN��k�144ĕ+WX�b>�O#r�1�h!���� �ɓ'����x�h��vi��n���}fnn��$�կ~���8�@@�X�V�����`۶m`Nh�v�Z	�A����$66�á�x||<0�j
���Bimm%>>�H(__�vM;�O��4t�k�.	��V��\.ME�\.�LLL�l�2�N'.$==]\.���>���B


��Nll,F���,�y�\�t���L�= �������m���hΝ;������������ $d��m��9��hd���SWWGxx8R]]��!�^����h���پ}�l۶M������bɒ% �^�_|Qn߾-CCC�M���A�������p�l�2IMM��p���S^}�U^}�U<x��vB̕<�Z�j��ɟ|�	��կ���ؼy����3>>��ŋ����s��QVV��ؘ.�add��/eee8�N���(((�ܹs���JOOF��{���=m�+�����B[[����Nms].gΜ�������Ç!�?���)))�٬�:4��x<RSSC{{;>�������]���r�8�<!5�*--�S��N�,Y�D$<<\4į9��v;gϞe߾}ϵx������fLZ�a.-
��͛Gzz:v�]�􅇇Ktt4��O��c�Z���N��k׮���@CC�^A�F�z�288�A���d�/���"��䤘�f��o��7n����Ǐud:22�Ν;�?��W�Z%��W^ѹo���*��`�]k`�X��!V��+W�<'�������1;;+���b�Z��)//���BD�͆�n��I��é��$!!���.������V��������	���lOc ���搾V~���J("�}	�Ʉ�n'!!A�������;v���&�P۷o�����j���Q�J>v올]���/������ٿ�tww���I0Dk0����o�>~��c0����n�����.�ׯ������b����*@4�KMM��u����p��96m���즦�x������SYYIdd$�����~溚s�Pc�9o���C)EUU��ArrrHOO�|��p8:�*++c�ʕRPP iiiz����̱{cccr�������̕b���$%%q��1FFF�����������۷��?ԛTeeeX�V��㏩������������dm&�IV�\��訴��s��i=�?~��@kk+%%%p��t���Gtt���v4����������xعs'�������5u�(�k�.~����¾I    IDAT��s�����9�!!!���:B�ͣG�p��`�}�6K�.effF�/_��ŋE+�>��b!������$���b���������'�HEE����c�Zq8b��ѣGx��g��8���O�X,��yu�� �� �����x8s�.����HO�<����iZw�
I�u�ptt���J�� ׮]CDX�t)��ᄅ��)����p8t�(--M��_~Y�x<:Y�v�������l���K�=�ʕ+Y�fCCC��hMoo/���n�###��f�(3�]��S)�?���ޚ�J)%.���^{���jB�(�Z�b��g�D�ߏattT�޹�n���ؽ{7N�S^z�%***#!!���q����������9s�ڼy3G�%33�Ç��ֆRJV�^MJJ
			;v������v�����;w�6(s��۷o�a����hll�[�������p��a������F*++���U�v;��RVV�y�Vz�r�����'QQQ��l��RVVƾ}�dff���1�^/�\.IJJ��^CD����K/166���,v���OEE"BII���k׮��vs��)9t�̥����Ǔ��'�/_FD�d2��brr���ŋ��ŋ	���K"""�z��t:�������������r���_������޽{窀;v0�|�^ ;;��MWWyyy�)I���o.477ˁ������Y�Gww7���: �.����˗IMM������(8jڹ��v������Fbb"gΜ�����JNNN��ݻws��a���?r���������>H4�L�a���$|>_��TUU���6�'���"�|�r�F#,��w�ahh�ɤ����H�V+k֬������O\\.��Ӊ��ԅ2###�x�bimm�n��%���]�v�b����f�bFu�GOO�DGG!<�������~v����̌�i�������#� �_.]��ӧO��v��;�`x����󑗗����ȑ#���s��9�V+���DDD���Ibb�LMM���0���̟?���R�{�=�� l߾]�^�l۶������p:�\�zU������F�<y�?TXX0����Ȑ�����+ٳg��J3�M��D�\�Bmm-J)���Ö-[ذa��������.�@ ��/Zu8r��)������E3����^����M�������N'������>��kA�����G]���܌�h�ȑ#��f�9��b�Jq�n�3==�����_K__���>"����ٳg���T/�W�^-?����_���X�<x��zv8\�~���.�f�x<���u������"@ll,gϞ���M`�k�	s(������B���$$$0<<��|>��Ʉ�Ps�D �Á�iڕ�����f�RPP��;wPJ���DCCW�\�ӧOk�!V�X!���$''�"����s��A�n��YYY:E��ovvVo��|>rrr ����%33���Q���K�f3~�!�����U]]}}}����bOmH�ڵk��~��򈌌�;���<z���Yjjjx��)333r��6l؀�O����{��9����y��wY�p!EEERVV���j����ǭ[��{?@uttHFF6��{���DSNN�`���n"""hhh��pHSS��/����b��'�êU�dbb���h<.����D���r�F#V����ID���Ǐ�{�n%%%���i�^/.�K �����I__�������H����{��&NaǎܸqM����^-\�P\.���jvvV�� �RIIIR\\LGGUUU�|>u��M=��jnٲE<HFF111DDD���V����n�Õ+W���eɒ%ttt(��$�mD+7�V���x<��>���D���U||�LNN��륽����lm�O9�NΟ?/��ٴ���v�Z���*�g�}�Ν;�V�;�^/QQQ������)ikkc``�W^yEg�����7o���|�����_�gΜaٲe����.PTT$f����֬Y#>����>�V+YYYJ3�`0(f����<�:q�X,***��W}>���������EAAqqq�����[���EEE��lV���2�|"##�~���{�.""999hV��~���HKK#&&�ۭw���u@v��֯_���������!]�1==-+W�TZ�t8266��˗u�Eii�ܹs���|>/���� z(u8�������ټy3gΜ���PuttȪU�|��*11���aY�v-���<~�������0��b��hllT���(���͛�^�Z�;wN�v;!�	�^����ɓ'ٵk�r��������?�1>����xN�>��^��Z����Hu�����TTT(�׫\CQAjkk�R@XX�hyA��effF����Y=�RJV�Z�ѵ{����ӧ233�ӎ0�њ�`�K�.q��������z���̟?�'O���z����uZ.�W^!���������n7������l6N�>��������~����v�E3��BLL�O��ǃ����,6���_~���IJJJD�J�:gΜ�:iR\\��+�_����	MD+�(�222$??_jjj�>}JYY˗/�f!����d2188ȢE����ϥ��@WY����#�ڥ�	666�J븸8���h��� �6�|>��srr(--��>����eee����|@TT�l޼���.\� �}���C��e͚5r��y�-[Fgg'����E�������n����ĳr庺:***���Ν;:��Ot��ȑ#�E�ǃ&���w�!p����ѣG���'//���d
ٻw���b���b��gϞ�0 �#�*++�s�α`����$))�������\�������266����֭��ȑ#\�|Y_����ڽ��K�.����ݻwuG[SB�!���x�Y)XNN�ɓ'O�ƍb�Z����Ç�����]�6������꒐fPedd��vu��IOOg������[�nU�E���/���W_}�����(6�����?�)�@��gϪm۶�_|AUU��F��χ�l&b2�hiia���ܸq��LRR!6Mt��ra����o~Cuu�*--�G�������ett���n�R����_|��"QQQ\�pASݨ��0	DDDp��y�.]JXX���TUU155E0�ʕ+,_�����F#aaa��4�)D���A�_�NII	������c6��N!���[�곇jllLc�DkaWUU���,===�����������~��8p���i��㩪�"""�ӧO���(),,$::���D����� �G?��������F?K�,�j��j��/�!�ܺu�ݻw%,,���Vbbbx����7��֭[x<.\�������ߦ�����6֬Y#����!����c�X8|��޼�x<�d�d2��1�Lx<:::�$V��ӄ(r���ݻ'���#���Daa!����{�n��\.b08s�LMM��V^^�o���CaWUTT�p8�J�gC�6-�v��ҥKDEE������?~\���FL&���z�D+��d2�`�������ի�k׮�v�uŐ���#�믿����~��b�he�E�.099�֭[y��w��;�����mh�x<���SL!y��b�0$�#n�[���ˢE�������h]?�d�9y�$7nTSSSRYY���UF�Q���z�� �@Ay<	���сRJ�AY�b���*�x�n�c�XtyWMMtuuQVV���������IXX�N�z<�@������H���WG��-[��p8p��r��-�R�����9"����UWW�sG�<x�@�������&���.�v���������0::�RJ�ٳGDD���INN���I=zDLL���dee��������Jtt��zv:���?��dee�RJF��|200�<x F����8rss���t��g$$$��۷eff��g�R\\,��Y�<x �<)��t������({�7��駟RTTĢE�����իW�v��1h��&n������	�u�B/���d2166��R�L&222$77W�4�;��p�����G?������b�_�.<��aN�)j��	|���=����7�|��	�ر���!9t����úu�ظq#EEE��Dcc#�Arss���������y�摘��RJ����˥��J�e�ٳ�9033���0Ǐ�������֭[��׿�m����k׮�+���[o�%F����i>��C�}>22"���,\�P�-[&��.�7�����իb6��Ne���(,,�l6˙3gd``���8���%;;���F�}�]����y�&�G���uFKCƚ���͛ttt�Ydd$.Ԣ�deeq��=IOO�`0�|�r����h����x<ٰa]]]���KSS&����>��Çh�6�B� b6�%����h4ʟ���3==-���b0��"�TFF�h���ʕ+�裏��!��������ֆ6��6��t:QJ�v ����%""���Y]��Ǌ�
�޽�/���G�4�ю����'��/������)..������G}Ăطo����uc�lق���ҥK���Inn���Ԉ�햺�:}L;�ꭷ������� jhhH�ggg���`��?55EEE���f֯_��͛QJ��������G������S����,��㥱���[�R[[��j�ڵkDDDp��56o�LZZmmm��_��s�x����j�*����Z�������BTT���/e�ڵ��b��8�NB"�+VhI��L&W�^���X�x<zo\��g7D��5�������+�n߾-���<+������4����c�֭:�������b6���ѣz�բ�w��^�u�|�My�Ѿ��o��RJ����`0�����^�v;CCC�!냢�ׯg�������8�Nz{{1����������drr���<|>���ڶm�|���ر���FRRR0�wޑ�� "��Յ���/���ph9G\�xQB!M4�@۰ӧOKRR��r��6�3 ����ʙ۷o˹s瘚�⥗^R^�W��v���X�B`��/(( 11��j�%Igg'~�_��������[��v�Uvv�����'NHdd$���ܼy���	��l
���J<�>�m0Tzz���W""w���D�h�"���բE�$,,���)�/_Nvv6~�_B�����d2�[�n���Axx��A�~����?����@ ��'OHNNV""���x뭷tQ�믿.��ݣ���o}�[ ܸqC)�����~%Z��t�RM������Ƞ���կ~����}�jhh����������<���(N���9���8111��Ԭ]������Ї�x<*t��L&���IMMeɒ%��n���u�[bb��l6���arrR,UUUX,5::*�?V�����*>>^Ο?���1;;�����՜9sFo���n)++S&�I<�
�K)���z����*..���1�L��ٳ�I�}>���<z�W^yE]�rEg+�n7˗/'j�F��z����u��155Eoo/>$;;[W�����d�#KOO�TVVr��e-K�.Uv�]�}�"�ɓ'���E;V�n����!�C��@������~�:::�X,��Ą>hq��1jkk�u����c޼y��h���֭�l6���@KK<y�$YYY\�p���N&''�ʕ+>|Xfgg��ӧ�����
�z%�Mi���F�,;|�0ccc�����K��d2����ݻw���M`r=��^��;�E��M ���0�~�w���\�~]�H��ܞ=���p`4q�\RPP��;22R��ɓ'�ԩSlذ��ݻw뿣]������ؘ>�	N���'�`�O���7������k�^�,X����z]�b2�t�����͊��%''G�[�l����� �z�����A)�U Ȳe˨����ׯ����(۷o�E�� caa!N����6����WOOIII�������k����9|��477KVV��999�2�E��������ׯ'??_�8���De�������ߗ�F���|�mmm�����`��YФ�yyyz]��A�>}��b��pHXX�9rD���f~��߉�`m���W���y�܆��X233�������ܾ}���lY�j�h�Չ'Dۓ�����F�4h#�0w��B4�oll��O?�ol��e��b������g�EDDp��-rss������8���~��Ù���믿f�<}������}�r��3ghkk�`0�^�-��NDD���LLL�n�:������`ll�5k�p��M&''	Mň�b���^nݺ����)**���������ƍ�s�����B!//��{�b2��X,�l6~���3>>�ŋIOO�h4�6�������""�g&���
===�Q�����>���:�ݻ���6	�f��l|�ߐ�O:ܰa�6m�٬����%99���(�s��y�	�����o}K�R-Z�/�Kq8a�Z�z��LNN�p�By饗x饗4i��ڕ���q�F\.QQQ̛7���(	��UgϞ�ԩS���Hmm�TVV��������بI���NDD����ܿ�ٌ�h��+W2<<̅عs'.�KN�:%III�y�f�F������}�] �q�F��򈋋���~���sU�&1�x�"���|��'h#��������uQ��Ez{{���������ٹs��:���@h��٦Ή'�Q���z�]�&W�\ѻ�6��@ @jj�lذ@���?%b0�T������}��a49�<���477STT��۷e�ʕ��ܹs:������ڿ|�2�@���^bccٳg������%??_���8s��J�._�,~�!~�!F��+V��b�ʕ+���Kuu5۷o-d_�z�7�|�������p���P�(�O�j���ѣG9{�,���h;k�177��J}}=ccc$&&j��M �ݎ��ahh���(]����"w��?��;*��L��w
3���D/$z��&d�mY�l�ݎ�.q6���d�lΞ��d�8�z7��r⢸�V�lUKD��{u�a`���?�{�`�s�ı��-���}���R||<�b	J�aaa|�������%���Szz:<<<p�����￧��z��ϸ�����rssQ__�;���G���(((��?���b���@�^QTTĝ�����j�����{<�Z�~���sbz���xxx`zz������/��j9+@~ ZYY���x{{�$,,			|R�m۶annׯ_�%777��ף��%%%���&�� ����y [������ӓ[���8;iii�J�|�lf.{{ي������8jkk��`��m�P\\L���d0���T455��ɓ�Ĝ�;�P4�Ka����{J�>>>8}�4"""hxx��������8<66�؊QYY	&�guKFF%''��p`||gΜ��O?�{�}#(��F#'�<��ð��d��Q[[��Bj����(**Bmm-A����ҹs��Z1{�V����;����އ��$��/᧘��eH؅OHH�L&#�F�����D�!�)X\\C�3����C>���o��⹖bccq���d2�v���0�����֭[TYY�XŀX�\�|�����0�Bpp0�z=:::p��-��r^�%&&"""�ZBBB،����(88�X�2??O�w�ޤ�KHH@FF�|�M�����BII	��� >>�FGG]vk��n���'����ŋ��J������xA*�ɰ�#�Q;i�Z�:�&�	�� t���d2����"ROOOl߾�N�BOO���g?���(��K�m������p8܉�
8����F����t:q����������I"�c�0Z�o����t�3�:u�ZZZ`6���j1>>NJ�ꁠ� �h4��o���l���v������j{u:���_uu5i4F����J�Ղ� W��w�^�����B����b����rrr�l6���BCC!����-�HPRRBQVVF
����̏�R�;w�$&����%�F�D#���B;w�dRtR��������N�# B~~>�R)���+�����'�|fX1    IDAT� �ڵkd�X����D)�q�8���{,(a����p������O>�J����ؿ?����d2QMMw���� 99.\ ���7WWW���5�����ב��ׯ_���?��R�p��qN�.))���%�@6�333����Z�Fyy9�R)Z[[��R�Ւ�� ����C;w�7�����hH.����7ݾ}v�7n�@oo/���6�JN����Gnnnhii�J�BQQ�����C"�p���������`o;�j���TN����XZZ������
Ah~~mmmT]]�W���Frr2���H.�ӱc�����^ϕM IUU1� +޹sJd�����d2��G�����������w�^����p0v���Ǫkkkߦ��H,8)$$����������������֭[�����;��hii��1�0࢜���j�͛7�-��}�555A*��b�`zz��Ν;�;�����x�"�V+w�����")��a��߿	�ʎ}��㈏���d""�< �����111d�Z�&�2�����?��?|�w:��������Z-��=�l6�����l		All,���!j-H����@6���Wn(..��� ���0==���,��őT*���)!!�F`��bO�J�y�0>>�^O/���;��^{�������ɣ(<<���X\\��c�w��Aff& ���I���&Q%��^]]�R�`0���Vpww���!���p;/߹siii�^��Z�f�F�=}���BXX��梪�
iii����7�l6� ���Dll,��� �J�������hmmLT^^���5�x���imm���|V�t:I�P��ݻ���BEE����GX[[#!66�nݺ���|����#����T*EJJ
|}}f�[__�099I�������\.g*�@t:%%%	���T]]���D��������wv��\q������///~�չ�g�xxx����v��j���/�]�`bb������^hyy���0��d������/���|6?00 �v*+�n޼I%%%P(��n'�Ӊ���/��}��x�Wp��U.\ݽ{7��ư�~477#++K�{�.y{{������H$زe��������� �Rɍ�l #����pBxx��T*������`�۱�1�[����裏(''iiihkkFGG��GEuu5w.1)���fff��ݍGy/^D@@�PPP@uuu���`���(2--������0q^^^��s�q�ƃ>�o:�Y"L	���سg9$$$`�����k��3�<�\��:~������5P���x�R.�cvv��Є���=�{��� ��s͝\.'�s9t�]�x�<�.]�����r���c||���زe�����6��9�Nc��ݤ�h`0��R����������"�5W`?�m�l|������F��������o����^���`�Z9��m��Ç�j�r�XDD�q����P������������u*((`2.aqq2��?���HJJ��>���`=<<����o� ����ӧOcqqgΜ�^�Û�ٳ� Џ�c��f�cTh4�R��@Y�Z�y�&1������ƒJ��N�C__�������%O�����$ .��B�@FF~���#//o�����P@@ ���p��Usb���N0����0�v����߻v����B��vDEE ����d�I��n����"?���6 'PVVFR�%%%d2���Zd<�^��c�=F2�mmm(//�g�}���v�����tr�����///���Й3g �JՋzzzx�hCP������-�,�R����C�(++�$�`�?��?���;::��с��e��j ���0��d2***����Y��� ���I���� ��7���f���I<��HMMEXX���~�R��rN{��/������LDGG�����{�j5�����;�f0pDcc#��ư��Λ] ����M�Q�Պ��u�����R���V
		�޽{QVV�OQf���Q


����������H~��y������":;;q��I�DEE{�V+�~�i�l6�T*�,�L&�={�Xrc��A�������O���$�Hh}}�W�;�}�EEEĈ��K�4>>�m۶��͛����F�:������������� \����f2�Lp88|�0111��֣Y\������q���QYY9�NdddPFFN�<�s�ΑF��P���\b�I�DBo��&DC����������ۆ\.����I�P0Q�p��m�d2b�����]XX@\\���PSS���������Z������`}��w8u������'�``` 'N�@@@ �?&���`�=�P�l6
�R�Dmm-������������4==�Z�{��f��vھ};�������z=�Z-�F#A]�v�����5���3�"A����`�N'>�����_'A���v���Rpp0fff�L����}�Q��v��r|��Wx�'��p8099���t�F��~xzz
sssTUU���0nLuss�#���"))	������3���58�N2����;�N'SSSp8411���u�l���HII�F���bA{{;
����N999��dhiiABB���QTT�B�qE���\�A�Ѡ������86�����՜�688�T�u�i�t:I���ICCC̴������$�T*Emm-��������l/f=���\dff��i���`��������ڗ �'eo-cxxJ��"���ݻ���@������CPPm��	W�\���(����V����s�Z����8�<�޾}�&&&PTTA`�Z��/�T*%��ƿ#s���U__���v���@cc#A�T*erk���������PTT���p�������999XYY!�J�Jŗl�������͛���AJJ
����#00�X��.��f>;���x��G�c˖-HJJ��dB{{;��9����@fm[�ҥK����<���,����������@8�<�1���*�:�Gmll\%�\�III�t�*e�BAضm�1t+����q��SO=EnnnĔA�����t

�(#�B"��j���׹xT����̄���7�|�g�}���G@@ C�	r���_H��Sdd$EEE1�;�l6��3g6�6��Ltj4�رc�~�:���9��������!�yC����9���Ɋa�x�"�zff&ݸqIII���6p{����w�}��>��?�J�ҥbmH6�HHH��f���x�ر"���M���(--e�Paa!�z�-��rv�'��a�[���A@BB�����/�.���/]�r&��uج=99�:;;QWW���I�T*��̙���,d��{���	�F:t�_��������_~��7o���`�	���?��-��R��`˖-�H$رc�j5����F�
���o�·G�_~�%�	@,�� �TS2�]]]X\\Ď;x��X��������#A����J�뀔����#   %%%�Nj|e�����hjll��n����(..��/��ʝ��p8��g���$	���haa���166�N���v�x[ZZ��O?�D"Add$��3����ӇΝ;�������@__-//c��Xغu+������z����$ƺPNN�p�������"''�fgg�^�O<��
�����Juuu$�H��* �����X,C#�������_}��dr�XTT555a||��ݻ�ݻw���0���b�Nq�
��N/���V+�{���qHDMM�F#m�f.SMvv6�9���?�Ν;�t:�p8 q:����Ah���X^^���(��Ǒ��D���`l �\Nccc<���%-��� ���˗/��ӓz{{)))	���: �,{aa���`����TTT�B ���G��Dm��j����Y�}}}���lt��=�n���������������ϗ����M������%''cuu�Oc۶ .�b�1{{��_������S�f3���A��=�����u,7�� ���III�J�t��dgg�u"ًg2�(//�*++��t�l6STT���`2�8�������v^�0zGkk+BBB�-��\WW�x%��p�!� �.Tqq1?v577Sjj*$	p��QLOO��l���h\�t	� `xx�k�����'��C��������رR�N����d6���w��3�ٳ�����H$������(155���X������SWWW���gϞ%�9��������A������뱾�����^|��$f4"11EEEt��U�F�T*8LOO����Hbp{�hhh���w�~��_���ǇFGG144�����c����9�N��d��娨���5Xl+��R)�K���EII	
!���<\�g�n���Ça2�x�����(��j�auu�O�233�b����eeeA"��h4B��QTT������*?~� GO&�	v�{���bA^^�mۆ��5�X,�L�71~�Z[[ P(,m�k�����L&�������AXXO]YYa颸z�*�����Ӄ��X��<SSS)++׮]��h����I��!33캈}��ˋ����L& @CC%''���FFF���xںu+L&���www""�����Ã�n݊�W�RVV<�������Y��� ��I��� ���n��D"Amm-�����t����?�8���Ν;�����{���Jr��A����w�}���ubqq�T*D!�������D�Z�ؿ?ahh��޽{������Mֿ�p����Gf����x�G���555d6�����S5fgg166���Y.�\�+f����&��B:�hmm�T���@���s�%��t:���Gff&OW��t��t����u[�J%eee�j�bzziii<n��xb҉��憌���BN���j5���_|���(���t��9�S"���xSmttR���(""MMM�~����:a���'O�B[[:::�������Z���X!3�&\�z=***�ݻw���������%�J��~�HN�����p��A���� <������Rɵ�L�w�^lݺ�333`t�#G�Pbb"�������������ANN<<<O���� #�˹�A&��ȑ#�j�" R��G����rE����hDuu5�l��J��B*�b�֭��ۋ��
h4R�Tx������ݻw144�+W���^����࣏>Bvv�F㎰���;ijj
v�{���իWq��Yl۶��������ȑ#�R�`���p8PTTDN��5
H�T">>���hii�2����������1D*�ß_�t�OY��*�
W�^���Xddd���:���2&���z����f��TN�BA7n���7044�����t������/|}}����C�!%%� �2���������U��#777?~�����j!ҽ n \��W_}��z�!X�V,--�_X�Ǻ���b�3 �eYYY����¸������������M!P���P*������$777�d2�� ��9ymc�@dd$$l)��� ������V��t����ѣGQ^^Nⱎ.]���� \�rccc�:P---Ć$2��!�J���A���|If~��^{��o�>bp1"��w���*�������D��?�===�f��011���4==M����",..�����		������rR�T����j���.tvv"**
��󈌌Dkk+$	RRR �H����;�v�b�������;O��@ ��g��֞:u�����x
l}��'a4a�ٸ`������İ/>>>�w���|+ZXX���)�N>x� &&&H�TRgg�k��l����������G�ݻwcmm�$	i�Z�/c� f�d{Xff&z{{��p ::�>�,����ͬ���p���I�J�$�H �R����.]��d��b����Ν;�J�g�Ν��}�ū�����W���֭[|uYYY��"���
BCC�LHH��·�zW�^ELL�����ߏ��j������V�����ϼ|�2�m��S��vwwSii)BCC���<��#صk������?���iCBBPWW��G��ѣG�P(x�d�X b{y��ۋ��A~߷o���?Qgg'�_~�eH���2��P(�~�:װ}���x�����Ѐ���������� ''���PWW��{�q����ێz����(++CDD�7��� ���XZZ��h���4�+W���@D������ FFF����O>a��x�"�n����믿�N�LFnnn���,�L�բ�������c\��T�����nGtt46�7�R)���-�l����S(|�.**"�J�U���ô��ʏ�l8����؟{��w���
6��W8p�� �,����|�IDEE!!!��ᴸ��Z���ԭ[�bee���ZY��j��R֚���D"App0��ݸq���Ҟ��niii�k��F,�8��b���9>>���طo����y:}�4���g���:���:;;�������HIIAff&)
TVVRkk+���s���i%ٲe���h���E������͵R������x&�����N�>>>		�ݻw�q�g?���f���O�̙3P�Tn566F��o�Ƨ�D���I������ "Bvv6�ر�� ��������Ƃ�$=�i4ZZZBdd$���QYYI���ٴe�x{{3�5---�8r���~Z��bbbp��m<���HLLDGG���6N�(""---CJJ
�?���(l߾�<==Y"(.�J`` y������h4r=��]�6�u������CJJ
/ p���)���@ii){�1\�vV�---p:�HJJ������#��΢���~�ar���p��m�J��r�
9�N����d2!11�fff��?���Y$ʷY`���e�.\�h����qf���ӧibb�bbb���n��T*���,'�
�������زe&&&�P
p�ܓ��!Q�ThooGxx86�����Hf��)����`0 888~�8����x뭷�������T�����q����0���ݻ��!�H������*Z�RI� ��eQZZ�n\6�V+��2��N�F#rss��Ԅ'�|>>>0�L������%___xxx`dd�Z[[�飷��������-��s��=~�����_���?u:owONN������t��e
�j&����:11A���())Ahh(�����O<!�¿� בtuu�T*��́�fff8AZ�P`�޽\��>;w��l���,�������-[��СC\�z��A������>l9���/����\.�\.Ǳcǰc���Ԡ��pss������������t��������g�������w��AKK���hll�VVV�j�B�PPQQ%''�l6#<<
����\� ��w�܁Z����
Ξ=ˣ���������"����QZZ
������z�Ā
A�R����233����F���ae��w�^���h4�d2!//�t:�F#������d����z�d2z����M�d21�;���iuu��l��ʢ���:I���(++�G���zbM�������H�"&ojlld�(
�5S(,�F����t��b9������/�̖g�j�HOO����F}m|��j5��v��j���# �h4@QQ�j������+e��m6���Q^^β����ܢ-v)1::��[��B�@BBT*�y�&��?����d���u�������% �m��_�N����������� ��ru����?)))�{�.���crr��� ׼���$�Bic#��g�Z�'N���"?�d���	b^ �����O��``�b!99��b����T �~�i2��T[[��p8����(//�FQ�    IDAT/���'A���EPP���`�Z�����*((��B�NQ|���0^#,//SWW���188HLj OOO�\� 499���@ ��7�P��p�(���7�ҡ�����]8q����s��!..�����ㅄ��h4�����W����---������(;;*�J���%wwwb����A2��8p� :::`6�y+Y�,)�J�����p 44��P(&&��������n۶m#��(H���o��˗/C��2� �*(11�6��V+BBBxx��n�Fqsɔ��att��񂵀�����ڊ����t��m����R*��U��:�µDk�B�7������ۛ~��C��Z|���Ã�_���N>>>��h ��Ɛ��Ob�/VWWI�T"..�U�`�B��\�믿���:�9���$$$�/�@w�ޥ�����������199I��_�F@\q�B����V"�Xsss���"t:D�.v��E�ZƦ�/^$��F��O���/�l6H�R�={��մ�Q�P(H*��/� �k�.b����	���SNN����w�^�$�j����AJJ
MNN��?�'�|�����N������ꫯ��� ����K��z��7����A vT�X,$�HP\\�*o�!�m`ũ���K/���<==��חDi�SD{����1�4 �i��"�R)o���j<����	�3r�9�:�����2H$ddd������/ ��q��a����dd0��@���$�eL�j���!����cjj�=�����ܫ���*kkkq��i���C�V���˜�QRR�7�+bbb�^���������[�{zzP__��q��Y:���<��믿Fww7���bddCCC���*���|�#_ �v�}���!T��>|QQQ������穿����X�
�*��������ɓp8Ĵ���Q�400@qqq��������������C��Vd�����bttIII��������aʝ�H�Ʉ��T���B"��`0@��ayy��x���5���488����7�{��#���`󜊊
������<�Y��d2�V��SO=�	�Ɩ|���N'�qn{\
�ip�VTT�����M�?6�N�999�L˪䆆R*���c����g�D���R�$�LQv%\�t	_}���j�F.,,��`@cc�&$۫��
"7 ������#��� L&��.�p�(������,~�b����rh4������T6�VK���Cll,���h׮]d�Z7U�L�GË�Jns�����hDCC���p��m|����� �N	F����Ԅ��9�Q3S$����K���� 777�����#��iGG�I###���"1v`VV����r�{rr2!66Z�VP�T�����$���QGG���Q�J�<������� �J���)b9E�Kd���)>��s�8�.���===���*���q�. a˖-����t:�>^XXX�ӧO#,,J���>]]]�C$���	��Aߵk1)YOO���`����ݍ��~������ׯ_�fol__Y�Varr�<��"H�R������2&&&�)999���8q��=*lٲ������!��j��Dq[�����ߟjjj777����+���544����������.]���8������ e ���!�h4P��صkO����&��j��jެ�j��:^r��K�U*��>��ɡ��d����j_l�
~~~<�mll���t��M>�b�!��<y��������FC�/_�D�~�:mD��ܹ�>��_������itt2����T[[���Hu`�>\D�����l��鐐�@������B�R�%]��Lz��q��rdffbhhgΜAcc#***6���b����:��޽:�v����X__���8p oo�M���0B������w\�|���u���?̜q��-���AD�������v�Ο?��Z���d�����|U__���H�R��tpssci����Eoo/���1==M�kξ������Bb`億0�����l����i8p �w�fi�$�ɰ��J���}�6������A�&��icc#>�����l���N�a����V���&�&�T*������R�� p��BCC���˓�ؠ��t�G�#�<���\F3!�ߡ��i�L&^�u\�r+++q���� ��577C��.�o�&��n߾�VWW����_�[�n���Q�������Ã��ڐ��F���/�����w�j���%,--q��^�����yŬ.F��ΝCll,���r��AC�g��!11�}�Q����B���C�P�F���� ��\�r�ț+lk����˨�j�6��'O�������o�A|����65���-,,AAA��#�n�֭[�u��1; _}�_EEU1.�@PP���9������w%'''Ӆ8ܫ�����/���
ooo^�?��0��\}%�,ںu+|�AH$6�ndaa!��ۇ����y� ����Z��p8055���~���'�G��������̇��s�qW�F1�:I�l6z��נ�j���O���� p�!g�`0	>�e��Bfh�H$TQQ��<����믿�DBkii!D��؈���'�ƽ�===(..&�V��[._�1�+�"""mmm(**Bnn.I$(�J�۷�^}�U �;FF��Μ9C;v���_���oii	yyyX^^�����|��7��Ȭe���`�T�T���BrssCqq1���a��H288�Ʉ��)��CG��K������x�W(::� �ళ�sS�FS	�������h��f{{{!�J9 ��x�Ӊ��@V�s���l��n��[�.���҅h`` &�����!&{�`0po@~~>:t��Ӎ+[ss3_�D�.^��T��'�LF����� �Ν;�L����Z6�7n���@����	���e���5�ڵ111�z�*��P�UK/\F1+..&�N���I\�z�7� W;�am���i:v�RSS�����)�@�N�~�����������Ǉ�������+���a��ߊo; ���.d2>��s$$$`vv�����|�=}�4=��SXZZ����T�6�E�] ---{��.!55�k웚���{���-mٲSSS���VVV���������A`�xq8L�BCCC���đ#G�����p���_ �O~��}�6&&&p��a,--add�������������-I�V			$��p��ު=v����q#���:2339��=�r��E�����
?����F�QX[[CWW����4fggQZZ*�t:�ܹs?�я���555d���裏rt+��򵵵a۶m����EDDh ��C���XZZbvk@,Ǝ=���J�������{����---C����R���^F��7??OKKK`����)�i��k+��&>p��F�9�N���AOO��۩�����ݑ���M]]]������c������>ãG�baammm�H$$2�	pu� WQ�������04 ۷oGFF�>}�'N��Z�&�L����d6��sIlq#))�jjjx���R@*�B	 �o�����p����������I��Ӵ�(� ������h4�Į��!##�1^~�e\��={�pO��~�3v� �����χ�b���9%-I�T��o�ş��'��O�y���T\\��-,,p��F5,�L2�^MM߳������������q*�/����b"� @���D~~>�J%���������$|���螞�����lnn�����),,Ķmۨ�������O�բ����������/����AQp�ƀ�V��x衇������*,,$v��ݻG׮]CNN�ڇ�СC���JKK���N.\|||H��������l����/��Z�VP�մ���J�������<���wuuѽ{�PVV�9,����۶m�Rh&Uqb��h�{�'���QAA�F#����R�qu���I]l���"dggcuu�wA�g��_�ݻwI��#77W��/())	YYY�� �H&��j�
,<�Ν;HOO��g�*ŷ���IJMM�3���|2�BOO�ر�ksrrX�����bff��v��I���X^^FTT"""����J���$�f��B�����۷QPP����1���{���>|������f����i||%%%����g����˰X,�����V˝)>� VVV ������������ɓ����p�>fo�[o�E����y�&$	C�ѻ��U����p����,�U����]ʬ��t��O�D����u�Vdff�ﲱ_�T*QUUEv�ׯ_g��&&RXX���y�rss������������j�����Ǉ:;;���GYYY`(���$Z�:�4�O. ���`.�a����6tww�j�����%���IBB.]���g���?��U�D	���B�������y��"���������� ��h���$�����Ӑ�����'��Az�������sρ1�P�`0�^YE�J�0��طow��ظ��5�����K�TJbuN����{�.l6���{�����ˣ��|<���s�Jo�����B���3�<OOO���G?"##QXXHl���'�ZM�����d��O
�Ʉ��t.3g,���e��g1�###` ���n~
@ss3fff��� j����\�#�xm�3XL޾}����x���B��ى��2:t�s򽽽ihh���p:�|d;33���!��Ә���cH��X,�t:���1ƅA@nn.bcc���&9cN`��<uuuX__ǩS�x733�����hjjBSS*++��*++��b�͛7y�5�ޗ.]��ڶm�����Z�$^u�����2�_�N.\@zz:�~:�N��t��&�p_m����^OYYY�\P,_aii	o��6i4���� HNNFUUw�����.^�___LLL�B���4[9ccc9�X�V�~X\\��lll,���122������@KKUVV�D"��-kv�:����"����h��\G6u��!g���9֜]��, ����常8��� ??�Q__OYYYXYY�&v���c�dggc�����ʢx ����u��������
�N'���~�MHH�V`����+�J���e���݉�����h���qqq477G������v�]]]�h4P�T���8������,v�܉��LLL������X|K��y�������V����������ԩS����Ν;Ɓ����w�RKK�<MNN"##�>�,�������믩���
�F#Y�Vbv��������X����aaag4133�eJ!!!�~I6�\:8����j������aeev�������GZZ�9��������U� ��
|}}���˼�dYYݼy��������ݍ�q4����o�����ը���V�E^^�G�ȑ#

���7�����_��}3�8���qhkk+>��3|��7$uH��������(�!777<��㼝��鐝�����3��p:��E$������#��f���� �������h4B��b߾}���,0�HWWy{{caa����\~6�
		�+W�pA�F�J\\���auu��������Tv����c.���Ɲ;w������u�����J%233a4�\""�����	d6�9�tC�x�;{�V+��f��r�{{{;���PRR�ӧO�)S ��x������uA)##�������V��R))�J�/��R��x��Ἵ�������Vh4LNN
������4��τ�z�������#G���F�僌���v;���B��������������*OMOHH�R�L&���	��Ő��O?�6������~ˎK�[QQ��z�D�-oyn@�
��.ZZZP[[����d8�N� �DƬ�|����CCC���CXX���D�Sg(��'O"##��p��	���y�4�׮]��KKK����J���	���ݎ�W�b˖-�v�C��'11z��������D�>�,����������iddmmm��˃L&��d"�͆��U<���(--e�� #""h���HKK������OM����N��޾��h�T*%///X,~�x/�G�l#������"]�p�$���x��7�͈f������A;v����:��k��3�cqq1Ĵ�B\M�L�������Ennn����K��0�}qQ���V�Uss3^|�E~�T*��꫼����G}}}����G}��j�:���jSSS�����8w��޽�\���f����֭[���L���4::���b;v���+���e_ccc\+p��I:s����~��p��bbb�Y^^�����f����@qq1A�N(fWg:M�NG^^^�;����^�YH ì2�OEErss93pu����ɡ^x�������v����b455���yyyq{ԭ[�PUU���~>�>t�ZZZx����2MMM!99�v�܉���@�
���7`�����_�,�d h�@���#   ���z=�����^UUVVV��OOOh4<��P*�HOOGPPBBB���d2!88III�(��Յ��9�߿����IC������Gmm-��jmme'h�ZV�Quu5����b��lV'�l6b�;���L&���*Z[[����:���`bb�v��	��B���LW�{��Qvv6/�H�����:�&V8xxx``` ������ �FN���VWW)**
R���c�qiRII	*++yRvss3������G��������s���$��		AHH�V+���7�O�ӟ��ӶA�3g��ڵk@FF---�`0Pzz:���;HJJ�����
jkk���D�v�\.��� ��۷��ZZZ8\2$$���ĬV�����)%%�G�l���� !!����H]]]���W�0���Ç7��,�n݊��Y""ܻw�7��tqϞ=hjj���� .�";i1����;���0::���Bܺu�&&& qww��>�*��rrr(22��j5nݺ����B��n&�9�N�h4�����҂��(
���|�:r����b~~�7B�v;��]]]x��)++����1??O~�!���y�+���������F���ґ#Gp��$$$ ,,���m6��SOA�R�n���Ã������q��[TQQO7�"�qsss����o�[��w��B��+Iuu5���`4inn�
���r�,�	�ڵ�7�J%�}�]�J��===�������#���A8<x��i```�3   )))���/)%%��m�Z-]�p&�	��{���"aE�F�kkk�)������tB�V���<�l60"Xss3�������~F�����a���O�ؒ������.�����ݻ������B���ޔn��[�������\�G�����عs'�������(�}IC���c���������YYY��s�m�s����N��χ�n����
���|:x��i������_GWW�gϞ�G���|X�V.mooߤ�a�+R�w������d�����\^&����	#��^�������/�*��˺Ҙ(���y�9���Cn�k���.��z��[��m�X7�u�G6M���6鋦�ڤ֤�ml��c�X�APP�a`��������~;�o�2������9T*�<y�k׮��r�ɳ(
fO�;w� 77f���[aݺu�n��Ǐ)((999iii$�$�|>b0*	7��hll�8\���@���b!�*COO<0Տ��XTWW����\�'�� �DB.�EEEH���C}}=��۱�������J ���������z!��!��L�;<��G����4W��c�X��-~�QV[�����X��  [IDATh�/^��p��lق��Ϊ����N'�x�<�d2��r�?���NN�f�8N���ꢔ�H�R���?�.�K��񀈸��
����0����%"BII	D� �%99��R)_�0�_�u�t:jll$&�$��haa�X�4>>�7o�@*�R]]�f3���`�Z�Yhhh���0����p�I#�Z-Ξ=�͆���|>.2QVV���h�u��nFYSJw85G �N �/�n޼���)�ر��R)t:1���J|��G�?��ܷoK���v�;v� 3�b>�o��6uww�;:\�z>�G�����Զ����Aذa�ݻG�=����%%%\�-55�����o~�/0**������!��W�^�^.�shkɘx �ŋ���Bf����\n��X6Kp��(--�3k׮��b�Ν;177��{����===�{�.d2�z=)
���ǉ'�`2��ݸq��9yyy\ż������~\�������,�U*���(""n�>�������X,������"=z�����믡V�q��e^<>����$���4I�RLMM����l�BV��ׯ����㩪��B�t=�@S&�=22��5d2�		S�����FBqqqh�1�%''C��᷿�-?�V����(((�\.���(����Ѯ��"�����H��4>>Φm����͆��h���0R$}��		ACC=z����J���������r�hZZZ�������իW100�ׯ_c͚50��|����E��BBBH��χ�G�}�����������41)ָ�8�x�0����p?33ås���Y����$x�^n��
䄄=zJ�������� ��ضm���Q[[K��egg��tbbb�������$ �ȭ�D�P`ժU�������v;���!}�>����CBBX_�R����{,|VTT�����+&� F�`�@�\���\t�DYY����~�z^ղC��'N� �_P]�|�|�T1''n��#�v�� �����v�I� 0]b�R�l6�j�8u�RRR��؈;v ==��M�d����$��>}��	BEDD�����v0�!�>^�AAA���K\�v����|�2���PUU�������{��j����ZM׮]Chh(mذ���=I���p��%�!"m1;;Kn���R)���K��j�\.455arr�|�_�^�����000�ǡj�����z���S�`;������J%?8eee�g�����tbzz�����L���}r9�4//&��M=88���X�n����]���8��6���'R�i||�fff�f����/!�J199������RLL�b.h6l����E,����r�3ٝ��B��f�L& �ǃ��Y���b��������O~�T���&x<�L&��r.Q��d�:;;9�J�p�����F^�uuu�lہ�%d�F#�y@BB /o���޽{��j���������z�j<}����\�"���������@Ǐ���<L&���(222�V��֭[G�C�]�֭[y�ɗ$n�7n��o7���Ma �C��͛FOJJBoo/�o���I������ϟ��r�wށB��ŋ100�C�aÆ�&��Ӄ�� ���źu먵��
�����\.JOOGaa!�\�A�(���j����_�����@�Ї�����͆�ϟC�V��ŋL�����\.��n�dӦMHOO'�Xyyy|@���V�!�D z��~ӆ={�`�����g�}�J�����.���/"�6�˅��^��z<x� ���XXX@ee%��������c���B"� ??�����͛7�؂��������#
��A�R�DSS�l6r:����!�J��ֆ���&y�^.`!��h�ʕ��jii	===LE�SۤR)2331==�w�y������<D3\btt47�d�oVV� ���C�VSqq1.^�H���t��5ھ};&&&077G�O��N��V�]��r�JnͰ������!��`@aa!|>�f3���U�����b 444 44����p477#""
�KKK�x�6��+g��v|��g\�.�T����իW`��$)�ɐ�����f_�o��&ܽ{71��@�'��K���t��% ��S�dK$�/��r��x���+//���ף��0�(ܵk�ru�=����װz�j���<���+����z�}ν{��R�d��<�2a���%���q�Cf���[�"??�ߏ��YX�V����V�Eff&���Sjj*޼y�����z�V��;^�~�[�n[�(�J�ecpp��H`5CGG��z���������d2����������0��`=���J����zb�I�>��m�(<<��V�n7EGGs��f���Yz뭷�A���$�ɸH�#Gp��5!))�>��3�ܹ�~�-�>�G�;(aaa|������0??�'N-+n�]��I�Vs� ��Ç)++��������҂��Q��Fj����\a�j�r雁�(�J$$$��p����o
�^�z���X\\��{��1$�|�	�-��db:��h� �:62j�(�B���ƫW����������e�N�$j �jY.����D�P
�d��V�����������nc?���0�y&k����Sk��a[[[����\���v���/c�V���ׯ_�s�93eeeQcc#O_�R�7nDuu5MMMA�7�p������ ��544���CCCB?�<����`����E���i~�و8,,���� y��)��{���P ���{�~�:��� CCCTPP��g@T��V�%6�+--�>� :��|>_ Thll���P���Pbb"��z�%�v�y-´�bcc��El��Q9D!&��z��z��n��_��@�y��p��mr:�`!F)g���9x� n�_D���{`��c�Ю]������O���ׯ���Lϟ?���iF�|>,����:;;吞���>���=�LX*رc���yy�^�z�
sssO ��?��6o�L�  11�fff��X�����8x� �����d�PEE绱��h4bŊp8�x<TSSC�w��5���R~~>w�d7O�o���*,--!%%.\�"	AAA�h4���̾��@�f�����p`ŊHKK�i�i4�� ����l������~���`��� "�T*���S{{;JJJ�4�֭[��]QQ�R���Djkk�Z�v�u�V�������t0i�Q���f����5�����ݻC��W�T8w����I.�s�scc#���H��1WTz����2-���f����8�,�<u�.]����LLL�g?����}���r����F�AGG�Z-\.���)((h�n�ј��ڨ��]]](**Bhh(���a4��_ ���CBB���y����FH�Rr8�?FGG���J���8{�,Ξ=����]�H������8p� JJJ`�Z9Ə�?o��}��� ":z�(����p:�P*��T*q��]bj����Z$�������e�	7n$���/^�`0��|!��G��a��o߾�TJ���8�9//J�o޼���"���C]��f�455���-���"v�����[�hz����[o����aatt���ۇ��6����j�Rdd��P �B~5���ۍ��VH$ w�G�"��# ߋ%�T*z��!V�Z�{�?�����_2Trss����RgΜ��'O�l6����QII	}��,R@�Ւ�hDWWT*�����BDDY,���GĬ�<x���a�ر۷o���<�DDp8�����8nEll,������TQQ���&R( DDDЪU��"9�l6��š���X����A���/a��0??O�D`,�d2�Fr�\x��	eggc׮]������"JJJ�hbb�D6�ٳG����Ryy9֮]U�2)p���C�c���a0��z�_��9)411���޽K�5,//���@FF�Y�k׮�3gΐF��F�Add$�R)RSS������
D�L�X4��Ǐs`Dee%�bHbb"ϳ������x8΋������1ܹsn���aEFF��h��n����u�� ~t�T*�F�All,fgg)--ccc����G��¾��������R���˗�	67n�6� ?U�wt:���%%:���bn�K�q��Ibccy�T*��L�-�V�%�Ӊ#G�૯����vddd���{��ᐮ��~���oUxx8^�|�'W�/_���uuu!==�u����������x��1��9�����z�V����>��ٺu+���Gff&�eee���!���Ʉ��
����ҥK����ggg�j��@���a�Z9<..111Ċ`������?��UVV���CCChkkCRR��Él������~�)��°�������dt��0�'�����BLL����V�y�r��]����@����e#v��Ioo/t:,={�6�N���N'�V�p��)>��d2G���z��梲�lj��w�!66�D,,,��ɓ��4��ߏ��>l۶��2lk� PAA���q�5#h,..�U�j����p���V������1�,��M�6 !%%�֯_�Qȕ�������icbb�j�*������Z���CWWO�L����,-bbbccc����O=�Z�����/��6���g� �����I>H��!_���FEE1٘m۶������d�ۑ��&911��7b���$z ```�IJXe
�7l칰��
18�h4����\���D���@ZZ���hkk#���y{���x<�,�RSSI&�1�������`EKeee���T__O�������	�����a?~�#y
���ӈ��[w���CBBV�Z����X�����6oތ��H�H$ܹ�b�`ݺuѢ�BCCQVVFSSS���l6������ "JJJBII	���x�c�+����IUUU|K
�����h���H$''s��hDIyyyt��l۶�~���A��������2���b�޽{����?G��]�͛7��� Ҩ���Y��z��5
9\"��I���r���ǦM�PPP@"�����w eeeaxx�����(vhh/^�@JJ
�^�+V��Ν;�X��+W���'�������/��������w���ظq#d2|>w�NII�V�������8���PYY���(�������$���b�p���۷�da��Ƹ��J�⾽QQQ������������o��[֕+Wr�z »�Kn����� ���"�B���d�����ś7o`0����ۍӧO���x����\.$	��eE1��`Z�V<~����������.*++I��܌�� b���EIV\�r�t:f�z�t��9����c�{�b�F����U�x�~��u���0��������r��Ç

"�ł��B���q{�_������N'T*��Ų,Ұ�nzz�5,--��C颯 )

�X���c��ݼ]bR4�v� ���Į�ٽܼy�����0�͔��J"Mp8d�Z�
���t��E����h4r�uHH�T*�F��e)�i��vC�R���8�N'$	���!Jؐ�"J����ZK ±cǸ��������������<��W__��䉉	������������` �\�ݻw���|>t:�J%����T*yΟ��FXXV�\���&�T*3A���Agg'֭[G���Q�v�IT��^/�e���DQQ�V+233�\.	� �ш��Z~m&�	999p:��׿���hݳg�r9���ݍ��n���Pww7�����t:q��=���q��r�\�g�n;������@�|��t:�������e��"�ZZZ���t8ڿ?~��A��SPP��p8�D"ABB���QZZʅ2��u�ŕ4l6Y,�j�<�~��t:l޼��߇�n'}���g"�P�T|��k�.����ѣG

�%�͆��)^�3�%&` �[4 HMM��l������288�= ~%Ґ���t���"���q��%��8�n��f^��OJJ� �j������� L&���q�BBB099I��333��G��ɔ���)7l� ��š���[\�sႂ�����!***�9�ɺ�6p!N�łcǎ��,R1�R����s��r����e�|����/
-..�z�C�233��h�1	�@�������0�F��f��^����0���`pp��^/禱/�^O������:::���#�ݣ��E�w����r��'O�@"� 11o޼A~~>����СC��?�_��/3~���4���`s���D�F0[���~�k��������������q��9tvv�ԩS�����رct��i �J�����d����т�� �M�6A.�s]C"b�%&&���ð��عs'@:��Ο?�͆ӧO�����% $�������RRoo/�9s>�mmmx��岅Xnn.��lFRR�J%O��|����S�L&�F#1����ӟ����z��ZZZP^^Nr��\.�5iFF��Ґ��N������|a���ߛ��j����ѣG��O��`0 ))	.��ѧ �����z)77��+ �6Q��1[;�
r���!z�H$�����jڹs'w�h4����O�Sܾ}MMM\��[�9�^��L&'d���A.�C���DD�	8�N
��1O!6�V(��q'O��\�,$$sss�݄�������(������G455!!!k֬��������D�Wvv6:::��� B���f��    IEND�B`�               [remap]

importer="texture"
type="StreamTexture"
path="res://.import/noise.png-bb7ee9b1cae22f59aa9c7a55a764cfa3.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/noise.png"
dest_files=[ "res://.import/noise.png-bb7ee9b1cae22f59aa9c7a55a764cfa3.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
             GDST                 �  PNG �PNG

   IHDR           szz�   sRGB ���  �IDATX����oA��Z���P)  ���(�+�#-���Xj�RP��K�J&�"��v"�2�IBB�RI��Z5���Nf�����O�|��������)8���t����?J��i�Q��N�' ��SRV����(�I�>��/�o���_Lp~1I��K� �R��l�j% I��Wp�v�og�X�8��� �c)�
;{������R; %�L8�O]
�s�~<��  �`Z� .�ZX��V<�AF��o_/� ����n� �tsm��D |<
2 J�� �Y������+SI�@A�zc @gP��j�H����\�#���ʳ�ž�Qo�Π(>�a�]�}� x�u����6}����e�\��Ǿf��D͌wقpφ�� ����.Әʳ��5���7��e0H�5�Ջ�x������� �Ʋ��6�b�>>�0vՃ��J�������Z��<�vB �����-8��X.�~k(ܚ�Ŗ&�I����vq�%#�R;�"�IJ]����r��yZ�ه���p 0�`��
�ɼY��3��a�w�{���0�B�\t4�\�:��iŪY��zv�6Ϭ�![)Ѭ�����S.���ś�`��ޙV�     IEND�B`�  [remap]

importer="texture"
type="StreamTexture"
path="res://.import/scarecrow1.png-dae8ec9afd517e0e73d9a4eb7f1bc7fd.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/scarecrow1.png"
dest_files=[ "res://.import/scarecrow1.png-dae8ec9afd517e0e73d9a4eb7f1bc7fd.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
             GDST                 �  PNG �PNG

   IHDR           szz�   sRGB ���  �IDATX���1o1���N���p� �K�,��	h;0��*X"�N�T�.��e+C)T"bh�.,Z	���R3"����g���J��l����>�w�n���������O�"��;��, ��rʗ���1������ϴ����l)�f�����+}�;e\��^s��^�F=�QO��9p�b���5޾���\j���~p�Q���J��*�����G �/s9WPџ��������QO����������&���#o��>{;��JW:��Q(��� �z�  ���E#:]� h�F ��/�nl\���)���F	���n��ܹ���] R�A��)c%	[�G
�;��
B��+�� <�8u�O�ϝ9�l �uڭQjC���c��lˊ=���$��A��w��L]�ִ3��R��'�����7y��l�v�T�52ւ�@T�e��b��k�S�QO��P��=:]�f�V���Y�1�팇���$S��S�����J�����7z�Z),���]ày	eֆ��]��t3;̍(��,�|�Tf�>�v��1���\�R�z��9����羾L�y+~�v4�����0�z��)�Ɠ[���*���= �L��O0�V��ր�\Y]��e��"	��cR6    IEND�B`�[remap]

importer="texture"
type="StreamTexture"
path="res://.import/scarecrow2.png-f3227a783f1689950de27abf7af96936.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/scarecrow2.png"
dest_files=[ "res://.import/scarecrow2.png-f3227a783f1689950de27abf7af96936.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
             GDST                 �  PNG �PNG

   IHDR           szz�   sRGB ���  mIDATX���?O1�G%c�|�Y2�CR��Сc�?Ra
K2$�(��ЁB��`ba`��J|�Hd��r���l�h_��w~���wQ�Y]
uG��i�ۧ��qD���
� ����Wղ�cT�Q�|���
X3;�r~1̻?#�d� �J����Z$��(�  f���:{��˃h�k	�]&UZY[demQ�Y��i(ߌ4H^�O�����j�3@�Uz �m��/bm�d� � H&�  b���cJ +�" �<@w�*��2 �\h���S ������\ R�GSL__:&y2��[�] �Ӓ0�ʓ��x�����>�$@���S�
�?h�6i��#��1�)[7hs�/Qb���A�,�ǭ���S�q�ʛ�ҥ�J-��pl��?�`s��9'�C�Y�+17۱�M sb6�5SQ����*�B�mv;^Jɷ�w���6n�Q�+���m���� Ǵ����9@9�8h�<�\V� ?��3v��F��f�o��y� �w�������p��{9 �j����K�+�o��RO_��[��K���hU14{�/p�ww��_BwU��`��W��\DJ~Q�8f�m�������    IEND�B`�             [remap]

importer="texture"
type="StreamTexture"
path="res://.import/scarecrow3.png-227191083539891c0ab73410a1ed2e9f.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/scarecrow3.png"
dest_files=[ "res://.import/scarecrow3.png-227191083539891c0ab73410a1ed2e9f.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
             GDST               �   PNG �PNG

   IHDR         ��a   sRGB ���   �IDAT8����� י�DT�NxҔk���^0qn8N/,Y��Z+;PU��BvT�R
�?d��9w2�ׁGFU�L�\rG)���F�9B  �8r�&�9�)�au"?���nټi#��?T�f��M�f!O�;J)�3�dӨm�. ��~�X7��iY����S=�'�    IEND�B`�    [remap]

importer="texture"
type="StreamTexture"
path="res://.import/stone.png-005a59f14bd4c49707ae6ded67307167.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/stone.png"
dest_files=[ "res://.import/stone.png-005a59f14bd4c49707ae6ded67307167.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
            GDST�  h           �  PNG �PNG

   IHDR  �  h   �2JQ   sRGB ���  CIDATx���kr�ȕ�ѤT2��{a�.��ޅ{av��RI�U�f�H �{3ω����j	$ ��Ń�                                               ��i� p�p8�^��6�M���z  X�  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  ̗�  �����Ô����YzY����0i_hb�q،nj�]3J�"�C �	���s��`�/�| � ��v���5� ��t���;Z�j��n��n\��~��dDf��a��$���ɭ軦��@d0�VS��"���Ž�w���@d��֧d{��.^D���\o!( ��`[��輻t�
����6 D%�J��,��[#�D  0� \Кa&�Uĉ[�e�C .�E��@ `
4����ݮ�?`Fx���ȓ���vK��X"j=��|g����q-�^__�n�׌�Z{�.��E���wi� @�L�.����B`>h*k=�;�:4��#��Sy�b���ӿ��S@@����N�O1Ho^^^f}^|||,�(C��C����nw�!xj�7b���߹����[���E9�[��e�z��L���d�h�}�4��|�d���>\���D�d�]r�A!8� >eڗ�q]	AZY;��	�� ��(їu
���3����w���I�  �?��K�E`���T��E
�S����@�h�>!����)��� L��GRK��;��z��O ���Y����r�GOOO�<K����R� �*�s�>>>��pI����|PCǔ%"0#��p�þ����T �\Q�/�6�=;jM���-E V���|8�߷o�Z/Τ]{ڑG�ӬQ�j��1���_��N�/�wh ���X�Hf���" ��Y���νͽ��>E��E[`�Q'�c��d��]"�&JtEYX���e٧��Y�_�)�#���pj��)`�W� �잩ߚ�	� ��^�8�#�|׈�Z�7�_{����k��K�xpk
�S��" o�q�ߒh� ��-�J)��T[�>�|���+K�_�o
9�����쓬���I���Y�gE6�u�ͦ��n��ߩ��k��W� �Ԓw���kL�ZF� \_��a>x?ؿ�q���;�]�W,�����·b�i^ XG��w$ 8�FpԇR���ӿR���/�Z�Ҹ��= ��  ��gL� ��	@ ��'Fx/�	�? `0���}��' �  �  � �!��-N;� c�08�;�(E ����� �! �[#� �E &�d�? � Lb� 0�/���>>>��S�f�R�n�u�;�;�s7���| ��10������pH�R���6��߲�w����L �:=%|+��������ۄG���j�qqd�6d�~\#���3c��v�c��@` �)l'd���������Y�k�D�� ��r�7�5��ˈ�t�a{n���_XJ�� ����~��J.&�p�Ka-��-�D�~2�s�gɉ�v�b��r�2l/�p�A����A�ڢo�k.�	`{k���}����K �= ����N��R�o�k-�XJ�\�Z��#��v�#0K��; ��5N⏥Eߎ�X>�N�5z��._�#`[Q�V\-u��i��8�>v4J �/`]n9�)�����dW;�v��A���%��?���|LK�7�@�!j�9h�R�mXL�5�ס�L ^��Ԭ���Ғ�G~��D݆�}�����������\� 2��%6���/q=�H� ��0B ��ߵ�]���2G`��+%N �
��X��"n��#p� ,�m
�e�xW��QY���I�G��~��0J����i`�pC�)`� l=�t�:N."-Lqۭ5	uXJ�)`� ,��)�������&Sf�?~��	s�v�����i}= ��J렲DU���A�e��ãa�! '�Wї/:����8C�Ȋ�\ ����m#s�3���o�W�e��T �a�K�% ��:�Z��^8�x��u�����
ּK���[�100�{3�c`�X�.�(����0�xL�([2{? �;N=.&>Q���!8Z��54�J�?4��F� .��՜ -�έ��85'������[����*F�: 8�Y�iⶄ	�,=4�.�:4lg��6���q�W���0�\���@������Dl-&q�N�J� @kY��W� d ����y�a�{��" �d���wL����5���]���������ߑ�  i���-���|�ĵ�s M�9>{&�	`�bp��;e tE���&�7��ށq��` `0�!�����#�Ç;p��F# �y���F$  # ����#��J 2$���F&  # ���a\�F' �� ��~ `8���8��� �� #���_ ��� ����  �` �0%��د�W�8X@?��p� �4 ?�1\'  # �
������  ��  ���z�e=r*l��j.�ށ�@�T�k�N�(���uoǟc�C� tf���EA\K��R�w� �N�uף�c�;]___7�9��M Ё��𘍶�s�&��X��i���s�@H�u���,=��>GZ`>	E<�F\��D|#.0� �d"t#/[f�����\' !��˘I��3�2?��D��l�e�,���iY)8�������������������t~̣1���r�����"L��ʔ08�H(Dx�yd���~/��Η�Fn6���qO���&FqY��vvB1�Y�)�#qp��Ph�>����F_�[j��Z��=5�ϙ B�j�����6-�,�~����4��.`j�� "��Z^__7S��9�����7�����ݦFB����F_�,��% �C��3��A� ��c@}
�E���#��:�� �0��ux��Z tD |Wk�d����
�#  # ��4,��}�L�ӎaYY�߬�3�N  F  F  F B0��.�^p��b�  ��  ��@_�~���y�� tB �$��E B@=^8��k����������z�z�~������e�ǩ�����1ooo��� �0���O+S��ڿ�19A�{�l�����
�f��q�^b�����r8�O��C]��LvǵT���8 }
h�W_�)�\�y^kL�Lc�Щ�#!z��������L�% !�G�)_�~�,q ��3M��3�}[j�>�s��ZŘlG B�Tk�8���5��#��u�S�k��G�100�����ǈ8���=��������b�eIԚ�̙�;]2	���q��{�u�� B"�������t�5B��{���S=�<�(ӿ#S�u� B2����-���k�e�h�wu�z$ !��݈�ԓ��o�e���T��o�e�Y��9Ҳ �;�k]x��g=�9��~�յ��0��8(G�Z�6�k��;�e� B'֚��8�s�^F��r8�:�d>�Վ����#��h�������RQ���>lF?�{�i�e;�n��v��~o$�Ӄ����0"��j���|��e� R�=!d��gx�	 G]O kEߵ�)!�9��	?`���w�w�@��~�h��5���������( ��k�_ �u� ���w*Ҳ  \�> #W�e 8J��C+�0�,�Vɲ������a���La�iY�1���A�q��S�ӫї�� �Ǥ
�̓��� �%U f'� �i֨�գ4(� ��h�myz����-�|]�z�e6�'1�����<�l|��zyy	�Y& ���wÚ�t#L3w��1ooo�(��' aSj"�މ��ZG��k#������#��ױ�)�(D#-e:���k��@H��XRK���>kO�_[i��sЦ��x���6K�����¯ ��a����&�����u�t�ؖ�
�8B��^��H����E s'��GbP���@�����F2�Ӿ\rqSbP��' ��e=E���7�K}pHp///���i�<��n��h���)�J���d`���L �9F���V���v{���(����?����[m�:�k,9_�'q�{)�'�w���z��&������\����H<�T4^z�u���5�Ne[k�2qZww7��.����Y������ZI�7R N'���6�i0������N3ޑ]3 gL��1��[��B�qpX_�m�R(��~��e#�q�������������a7� ��v����~�|Q; K����4!���>w.�(�f �����5��0������M �q� ��~�W��10=���� Zz~~>�����Y� �~���"W�e��)������
�'Wn<���90����e�s"����ļ��R���3���w���� ��p������E~�r�e[B��yو'S�e\楄@�z@`$=��R���&�~ ���04�ߠz�^ãR`���,�N��v)�7.�,jtD]�%���A7R �Q�#�rAU=M�zz-�H�=L[��a
Hf?�z,�����1�z|MS�	�RrG`���O��lw��� � >{��n����y�s�<)����p��o��m�����A�`5D^__7�C�c�L����h��A����3~��i�{)�_s�#Gt=O�F���'zF��#8_�m���~��W�Q������x���:��뢔����5���/���Q���M S�r.�5� �,7dYN�j��+e��ZJ�S��"�@)�O4ZJ=<���[�E����S�is����S��.�~��h�R�zͩ'��+��_��yIF|-�� ���k��b(�hi�����20��!��ֈv�i��K��M��v���~��W)�;c9?�/����_�'e Nu:�����������k���q1Ʉ��삻�ō��/A��F���(�N�km�S���OOiϖ��s t
8��X<����NW�q�ƶ6�4]D��_}#`)c<0�l�A����q��=nFc�`LG�#p�3���`}����	�@"l����#p�IS�S���'��=f�|�g�k���o��-	� �l��#1�eD9�" ���!f�@�W������~�E�5� "�_)���@hC�ݧ�gV�A8B v� ����'i��=]�ѦG����1�u��M���So!8�0_���a��oYF���tk�q��7oQ_�)���(�P ��$�%��i�Y��4����L��8Z�_)��Y����ӿS�'��o}>|�7&�D���:	a�W�	 T�@�-�J1	�N >(�`ӿvD �c�-b�����`�ӿG�"P������r��\�T�k�_<��2����4Y>c�\8����E��@�[�ihM�M��s%C���N����c���ooo����f?�������#0ڵ�|����̓m�W�B�	�=��=w�֊����{�39����j�)f�\'x+G[�"�_�P��O�ώ���x5�m��[���&�9�K�ň�WJ�S�0AFd���L ��Ӄ�� �}D4���@�A�ٮ����(w��@����؞!���ia2}D7�����B����� $!�J������ �d� Q?2?�����G&��P�������j�a�� ���1�P<FR��#+�w� �N�A�!��N�M�Mr
x:s�AΉ�\���߾}��3�3����L�O���w�p�F��l���T�DQ������	�@;���|d ��	�ƛ NcǡQ��O��жG�	�����?Z����`��(PC��9H�p>����-�u,!'���~F���g��`59-�� ��	@F�1�kɲ�'�	�BD��� ��G�����  ��Un
��� �D����e �E����_Ҭ�ѧ�� �e(��K��F�@��T�#P��n%����{���/� @��2�O�6������
��Ү��#P�P[�~��^��F��`S�P��'�
�-� ��nb#{
? `-]EG� ����l(� ��u�CP� �t!�BP� �#�CP� Q%k��� �:N��A� D&T�̍B�                                                                              ������6s	'�    IEND�B`�       [remap]

importer="texture"
type="StreamTexture"
path="res://.import/texture.png-59546a6b6ae00ae598d09228d4c66fd2.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/texture.png"
dest_files=[ "res://.import/texture.png-59546a6b6ae00ae598d09228d4c66fd2.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=false
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
     GDST2              �   PNG �PNG

   IHDR   2      �j�   sRGB ���   ?IDAT�M���@¼�1������ �m�$��t�$I@��� $��4~��1��|�KϿ-�,�NIxǊ    IEND�B`�           [remap]

importer="texture"
type="StreamTexture"
path="res://.import/worley_noise.png-dca0570437ce198350d2a0c542f4796d.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/textures/worley_noise.png"
dest_files=[ "res://.import/worley_noise.png-dca0570437ce198350d2a0c542f4796d.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=1
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
        [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             GDST�   �           �  PNG �PNG

   IHDR   �   �   �>a�   sRGB ���  vIDATx��y|T����̒�I&�� ��-� (.� X�X��Z\z[m��u����Zۏ��^�Wo[��V�
��RD��Ⱦ� !		IȾ͖Y��I&3��̚Lp���9y���<Ϝ���<�+^�C�f�4
,��X�� J�X����$"I��(��$I�I���!~|�6���*�T��1Z=��b��W�`(%�U(5�#9V	qa��(!@B�#�Y-�ǁ��	@4a�8�J�T�U(��$��
�  �	��F�P�+�굀���}�6aC�����q��>$@=b=�RP#�����S� .����F�,F�P.
	�1����\�L��L���24v�$	�Ռ�jFr8<�.���b��!���	@/(薜��� �,@��D�*yL�e���e
%J���&,=E C.�Y'��� ����HH1�A<�/WƠ��G��1�<F�L��b��f1�����E�X$ �D�ɩ%�s� �v��B�!&6!*�1� ��&�Pi����ЙN#PgrdKw��+cP����XG��C���8'	��t&G6���ӈϺ[��(��ďpW���&A]��&N#>�AR��ڣ�:.�ڿ�a����$��$��}�EQ�\�"ʅ�\�Be�cA�$�����L���E�V�QpH�<yQ.�e+8�i��5�d2�\�x�V�t�4�B�H������Dw�Y(j�_�x�V@���U�
9�
X0���E>Qɺm�hn���)�ܲ�
�M�ġ�<^���X���+���K�H�'b���W6�4.���Mw
������p8�|�Q־��֎n���������b�%sE�W��f�ЉJ�����'9]{.�{)��cNT1J��|>7-��)r|��鋽<��~��{na�Ջ|*[V]��~���_��l񫝑f�*���tn^~)+�\D�fp�tm�����(>ۉC��?7;}[6���?�u��>����������j�ՆbDA`v^"OJa\J���F�� ���nj�-3�x+@�� ��<u��(���}Um�;���������gڙ7!�L�Oo^�S��?>�y���]�?|��#5 :��_wU��d�$NJa��T
g�8��[V\�-+����
�~�=�Z��A,m��߹�P�����{װx��\gۍ���/l+���f�[���u�;M\73��y���s�N�a���s3x쮛{-�綜�M�X&���V_���ёz�2�$��#���S�NK�o�p�����y�� ��/��| �$�uE������)k�a�KC�o՛)�Ԓ��A���bo�u��f
�9�f��V6����.Q֨c��zJ�:Q)D�5����J��=���]�o��Y�{������9�3�OR|ֿW�;���$��,�d���[�p|6�\�$I��o���V��N��|���9�:�~�HD� C���Ke��ݕ�\V�� ܷ�z��~+�q��S hhn�[o��p���������u�k�O�E�t��3[�T�w��oΰ� QX<w� ���$���3���W�{�D"��3�?�xU�!�gZ|U���쫲fjچ6�½������7�V\»ߜ����4t���1�m�w:�s��h�rT
ىj�����{_#��
���j�� �u�X���`���}u��H$�?]nc�� � #I�� � ӭ�0Ҹ���"��V �Y�`m��Ľ���<�6#b��f���Ig���'O�Tg~Qܶ�u�0������V�3�8t�ҧ��O"1>��F����Ea{�1J�>t�/��q~�־�����A�Ūcx��Uܸt���V�y��{_s3S���c�����|��4�}�d���7�䢙�w<�k��l�Z/X��x��;�r��'�d���Ũb����f�w�����O���]��=V^���w��	I�F�����21;/eo�ʴ�y,�t�W���?èV)�������ocR^րk��NgBv:��9����3��5+=~�����4w�)�p��d"s�M��%i��QY{�%�`��~FrB����-���c���/�'�n1�ى&2U��m��W,������fV\�����s�!���cێ5�UY3��'����B!�@IE���V���\�B~{�]�����t~����B�e'x�9]{�I����h���S��-�#ҹ�0�G���F��ŭ�kdbn�G�҆.^�QAe���+'q��<�����|���A��; $�o�y�'���?B�C��t+/}R��,|r���NS��]��W��i��9Q�p?"��v#�+[Y����w��ߟ�צ7�_�W�/+=�Z��tP�Gn�3�{��i-��\KG�}	�' '#��~�ohTμªf=On,�g_�j`�1g ��L�Ka��t�ĆbZ�c���n��'�(�В��i���|��,�~|��&݀:��t�SH�U"E._P�{��L��BX@^z�.�g;?mz3�PLw��-W�C�hm'_�j&]�����f��u�:��/K����Ӯ7�M��]ъ�q~_��!����%Sӝ�
�����x�~� \�aQ�۾{�+��fw�Ǩ��mLo������g�u��)$���vv���7��[`��)��bYQ&�(������±�j��yDP~n�+lཽ5��΢GE����ָ����w������� 2����~+J�Ә+;�ͺ}�Aw*���WKY�X�������1|��j��K�:�9L������@>LQ|�!I����^;i��<��ƥA]3`HN�����\�o}]E]{d{�.�ڍ��u������HN|1��@��q���u������QB��Cu��9���rjU��z�������#	�3+���?^_Z��%�!�P�Ṥ ��E����������_r?�l
I��S�&I���eS\�ۿ>Dck�S�A}�s���x����O�F�`yh�W�ackϿ�!��� c��}W�բ�)�d�(�纙Y,���f�$�߿�>cp�@�F�����������
\Ύ(�#+Q�=W���o���ǃ��(��w7SU��J!��ME�씸1�(�/���Z�����W���k��"V���^�Wx�����p\(.���qL�q��z���6p=�@YXxYuol��:��	.��8*���.��:~c�vʪC7�Ҩ��c?��R4��21�π(Lώ� C��-y)�ڍT4�h�Q��=�}$��Ӳ�)��R��%7Y��6#�M:*�t�l��G"
 �u�{���;B���*��!a�Xin�t��B^���VL�0�cK
3�\5���n����Rδ�n�ń�X_1��4����-WOw���I���r6H_����b�yf�B.cBN�Kk��y�v����&?-�Wo�Ϛ���N(Xs�x^�m� �{S�����sӂ�!ˍaK�^\��-��K&�b��������c��G�(d"w\�Ϫ���JV���K�Q�)��f����~��"J���.�ĵE��6�DL�U�6�c���Ǜ?fݺ�444��M�6��y����'r���s��J�KV���\>�u|���|�MN��r�����[~��߽ޣ�=Wp��#b2�"&9􁥓�u۾�j���c�䥗^�>���S<��G��_� ���#~NC�icX9+����I���N}d��������Q�444��K/��c��j���������D
� *��������[8p`�z��_�W_�`fn��k��M�/��k's���y�����0|E�>���� �ڵ���^��������<�-�O��!rD(���8� ����_��Ou׾���9)R��[d̏/���J!�x�E_v���_Z�S���?�����X&���p
�-����|ܝ����8�e�d���]� ����F_555tv��f��ᠤ��9_�5�D���y~�+*|˥�.��x��6��ce����<ZD�T�x��C�x��:ᠯ��6}���F���
P�"��)�Yɓ';�W�@BJ_S��7�(��ڹ�=�� ��FniRs��!5շùs琞���f�i�3�,6;iii̝;ǧ:���̙�_�`�Q!!�� ����<���8��#��S��<��GxwO͈8�l�w�8��G�(j�����}���~�����E
 ��H=��V���E<��'��<Y5''�?��<YYY���fÁ������\7YYY�����|*:66�'~���o=s�l'��ԏTW�%b��^�~�Wo���Y���̙�֭�(/+������\�O�Ί�+P�T�6^�V:�)iI�m��r�|���x�Ϳ�u�VN�<I]]���L�2��+W�����6Yyq��!�<�D�4u�����S\y����q�탖?X�������W��,����w�� ];��ɬ�i5�oZ}��{*[y�2:��Y�+P"J :�V��t�k�epü
3��ܯhұ����%�m�V��ͥ�i��K���o><�u3�X9;{�[�$*�tl:\ώ���� }�(mr=���8
3��n�SѤڀz��
��U.�U4�xmG���Kα��N����8*�tT6E�Po("Vܩl҇�a��-���!r��|}Gh��Pޤ�|-�1& \�J�c��F�
�-'� �rBn��>��r:�Ztft=V�z0Y��u�XԴ��%�G9�{��O�E&��R!���A�����B�R���!!�)�!W �W4p�FI�7�$�>}�M:��{��h��k�E*q1r���MF�ʵX�w�h1� Q\��3Ԭ��l4�4w-������CIX�W��LP����O�E&L��.�`F�o�������������f=�|"��s_�oqͪf=vI��Հ���go�P۾V8Y���z�|LL�CaBJ,
�Ȣ�)\<��f���(/h�LL��_.��??+���=�=�ʾ�6�6g�8�G���k���'�������-.f������̵��a۱s�|���"�
����q7�d��Z!�d�?>'�?f�o��~��&�p������B�abк?C�����r��hz.Ԫ�~Og�t�ƫ~_C��{$��v��KP�eܾ��Z�]��NT�7��=C��q�'/^��^޿�t1_���2��]'���w�y$�y��w��JP����ym2q�������5��Aw!q���`���0Z�(=8F&�u�69IjN�y�B&0��^��(��yߛ/d&����z�r����Z.�3�Yy��*o��.�c��R�nZ�7h^��!�H�����v,���x��;L�ɛK��NT�C�v�HF6�r(=V���;}y��|��&�
p�D%w��\E|N^�0���E?`g1od��1�0;/i�r�A���w�+��T�nu�� ����W(���&�6@I�L=����Xf����~^���6*�t�6�	&Y$�D]���&���x�s��7;/�e{�z��������`�Xٲ� 7/������X�oI�}T����ƒ�ǧĢ�ٵj�̵�Z�F���O�URިc�ц��-��$0=;��n犜-:3��6E]��5B9ݬ�!IXm5m�1�n���ߗ��XC�	�D��m��i٥���T�K�h�J0���1�aWF�����x�����\������_S#0�2�X�����C˦�}J�BB�������Ͼ9J�9��i_	�T���ƭ�	j~{��Q%�\��UEd&8���:/��a���D:�����F���	���ƙ�7���E��z&�'�������_�Lض���=���`�gjtf���	�*o��U>#�B�37�b��p���ma�'�C�Έl�Α�*�+g9��3�U��Kd_U=�w�XH�(������_y�#���E��q (.���`b�i �iU|gV6�����3}�*� 7����U3�v�5��_?d�֝aisT �DE�]:.�W�lG.� ?����i5�!'�E9	<���\[��a?���cç�}��3j
 Pz�,�e��'Q�l')V��Yd&��nя� ������߮*�XԪ���_�}�{��ھ�ӗ��x�&����������'����aI]'���cWy���|�\�)�,�������on�����j�7_1t4{��������?��k.�֎�bc�f>=�H�0n�HeZv<ˊ2Y25��9t�o����M��w�X�"J��;}kV.��E�
 �fN�ws����T�Df"I~Z,s����x�c�hw8�u��o�'GJ��Jx�H�#)>�K.b�U����8o9���Ɇ.N�wQ٤��hq%���q$j�dĹFCE/U�5����lٹ?�;��
�������E\s�l��|�jӛi7X�l��i�Ҭ�A�����qd�q�k�ݬ�^Q��Zҵ*5

2�$�*}^�Ko����l�rX\��0f�����(d�ԉ̞�Ozr`�&ᦩ��ce�=UŁ�r��7_i��
�MVZ��Ld��|�s2HI�2!����pP]�D{����&�OUQ|�:�=|G�B�Gvz
)�Z&��"35���XA`J~�G��X59��]u��茞�c��� ��n����m��SOCsd%w����zfP(ihn������3�ݕ1�(!yXH�.�ed񖭄�Ah�,ta̾E�@�
-� I��=i�D޲$�Y��#��n�vy�Mx�V�2�=��Fel0@�E`��!�pرYz�raa���p�ze�MD̂ lt/l5���I����� a� b{�Vz��'%Ir͂8v,Ʊ邍2�����/I&���k���
�E�t�d����"��(Cc1�Y�{���7/ ƹ�cx�nh�1b6tE?cI�0���x�*�+��
g�<F��j5� +r�aA�����b�nkC��E���QF�ل�ǀ䵦�$�b��V�5
�y�����aH���^��F�rE2E2��K�D	=v�$	�Ռ�j x 	�l�x��~ �����+4 {�&���b� �<.�p`5������%$8f6Y�+���
�X$K�����+|,&@-��W$�J{�"�	�W�E@���4e���,$�<d��&K���$$�$�Y����C���[	�	_ջ���b�7�V@. [����$"I�l�ed�$	A8	�C�#:�O$l6p�P�T��(��ݲ�n4#�� (c���C�&�̭    IEND�B`�    [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
GDSC                   ��������¶��   �������Ŷ���   �����׶�   ��������Ӷ��   �����������¶���   ���Ӷ���                   
            3YY0�  P�  QV�  �  �  PQT�  Y`              GDSC                   �������¶���   �������Ŷ���   �����׶�   ���Ӷ���   �����������¶���                   
            3YY0�  P�  QV�  �  �  PQT�  Y`              GDSC                   �������¶���   �������Ŷ���   �����׶�   ���Ӷ���   �����������¶���                   
      3YY0�  P�  QV�  �  �  PQT�  `       GDSC            %      �����   �������Ŷ���   �����׶�   �������ض���   �����������¶���   ���Ӷ���   ����Ӷ��      @   �     h                     
            3YY0�  P�  QV�  �  �  PQT�  �  �  �  PQT�  �  P�  R�  Q`        [gd_scene load_steps=22 format=2]

[ext_resource path="res://assets/textures/texture.png" type="Texture" id=1]
[ext_resource path="res://assets/textures/gradient.png" type="Texture" id=2]
[ext_resource path="res://assets/textures/worley_noise.png" type="Texture" id=3]
[ext_resource path="res://assets/textures/clouds.png" type="Texture" id=4]
[ext_resource path="res://scene/Clouds.gd" type="Script" id=5]
[ext_resource path="res://assets/shaders/grass.shader" type="Shader" id=6]
[ext_resource path="res://scene/CloudRect.gd" type="Script" id=7]
[ext_resource path="res://scene/Light2D.gd" type="Script" id=8]
[ext_resource path="res://assets/textures/scarecrow2.png" type="Texture" id=9]
[ext_resource path="res://assets/textures/scarecrow1.png" type="Texture" id=10]
[ext_resource path="res://assets/textures/scarecrow3.png" type="Texture" id=11]
[ext_resource path="res://scripts/GrassPatch.gd" type="Script" id=12]
[ext_resource path="res://assets/materials/cover.tres" type="Material" id=13]
[ext_resource path="res://assets/textures/stone.png" type="Texture" id=14]

[sub_resource type="ViewportTexture" id=1]
viewport_path = NodePath("Clouds")

[sub_resource type="ViewportTexture" id=2]
viewport_path = NodePath("Grass")

[sub_resource type="ShaderMaterial" id=3]
resource_local_to_scene = true
shader = ExtResource( 6 )
shader_param/wind_speed = 1.0
shader_param/wind_direction = Vector2( 1, -1 )
shader_param/tip_color = Color( 0.996078, 0.976471, 0.517647, 1 )
shader_param/wind_color = Color( 1, 0.984314, 0.639216, 1 )
shader_param/noise_tex_size = Vector2( 50, 1 )
shader_param/gradient = ExtResource( 2 )
shader_param/tex = SubResource( 2 )
shader_param/noise_tex = ExtResource( 3 )
shader_param/cloud_tex = SubResource( 1 )

[sub_resource type="Shader" id=4]
code = "shader_type canvas_item;

uniform sampler2D cloud_tex;
uniform vec2 cloud_tex_size;
uniform vec2 wind_direction;
uniform float wind_speed;

void fragment() {
	vec2 uv = SCREEN_UV / (cloud_tex_size * SCREEN_PIXEL_SIZE);
	uv += wind_speed / cloud_tex_size * normalize(wind_direction) * TIME;
	COLOR = texture(cloud_tex, uv);
}"

[sub_resource type="ShaderMaterial" id=5]
shader = SubResource( 4 )
shader_param/cloud_tex_size = Vector2( 640, 360 )
shader_param/wind_direction = Vector2( 1, -1 )
shader_param/wind_speed = 5.0
shader_param/cloud_tex = ExtResource( 4 )

[sub_resource type="ViewportTexture" id=6]
viewport_path = NodePath("Clouds")

[sub_resource type="SpriteFrames" id=7]
animations = [ {
"frames": [ ExtResource( 10 ), ExtResource( 9 ), ExtResource( 11 ) ],
"loop": true,
"name": "default",
"speed": 5.0
} ]

[node name="Node2D" type="Node2D"]

[node name="ColorRect" type="ColorRect" parent="."]
margin_right = 634.0
margin_bottom = 360.0
color = Color( 0.529412, 0.752941, 0.517647, 1 )
script = ExtResource( 7 )
__meta__ = {
"_edit_use_anchors_": false
}

[node name="GrassPatch" type="TextureRect" parent="."]
light_mask = -2147483648
material = SubResource( 3 )
margin_right = 640.0
margin_bottom = 360.0
texture = ExtResource( 1 )
__meta__ = {
"_edit_use_anchors_": false
}

[node name="Clouds" type="Viewport" parent="."]
size = Vector2( 640, 360 )
usage = 0
render_target_update_mode = 3
script = ExtResource( 5 )

[node name="ColorRect2" type="ColorRect" parent="Clouds"]
material = SubResource( 5 )
anchor_right = 1.0
anchor_bottom = 1.0
margin_right = 620.0
margin_bottom = 355.0
color = Color( 1, 0, 0, 1 )
__meta__ = {
"_edit_use_anchors_": false
}

[node name="TextureRect2" type="TextureRect" parent="."]
margin_right = 40.0
margin_bottom = 40.0
__meta__ = {
"_edit_use_anchors_": false
}

[node name="Light2D" type="Light2D" parent="."]
position = Vector2( 320, 180 )
scale = Vector2( 1, -1 )
texture = SubResource( 6 )
mode = 1
script = ExtResource( 8 )

[node name="Grass" type="Viewport" parent="."]
size = Vector2( 640, 360 )
transparent_bg = true
handle_input_locally = false
render_target_update_mode = 3

[node name="TextureRect" type="TextureRect" parent="Grass"]
margin_right = 40.0
margin_bottom = 40.0
texture = ExtResource( 1 )
script = ExtResource( 12 )
draw_radius = 20
cut_length = 5

[node name="InputRect" type="ColorRect" parent="."]
margin_right = 640.0
margin_bottom = 360.0
color = Color( 1, 1, 1, 0 )
__meta__ = {
"_edit_use_anchors_": false
}

[node name="HSlider" type="HSlider" parent="."]
margin_right = 161.0
margin_bottom = 16.0
max_value = 7.0
tick_count = 8
ticks_on_borders = true
__meta__ = {
"_edit_use_anchors_": false
}

[node name="AnimatedSprite" type="AnimatedSprite" parent="."]
material = ExtResource( 13 )
position = Vector2( 85.9019, 260.317 )
frames = SubResource( 7 )
playing = true

[node name="Sprite" type="Sprite" parent="."]
material = ExtResource( 13 )
position = Vector2( 370.282, 219.839 )
texture = ExtResource( 14 )

[node name="Sprite2" type="Sprite" parent="."]
material = ExtResource( 13 )
position = Vector2( 487.883, 122.368 )
texture = ExtResource( 14 )

[node name="Sprite3" type="Sprite" parent="."]
material = ExtResource( 13 )
position = Vector2( 47.1461, 48.2056 )
texture = ExtResource( 14 )

[node name="Sprite4" type="Sprite" parent="."]
material = ExtResource( 13 )
position = Vector2( 577.408, 328.963 )
texture = ExtResource( 14 )
[connection signal="gui_input" from="InputRect" to="Grass/TextureRect" method="_on_gui_input"]
[connection signal="value_changed" from="HSlider" to="Grass/TextureRect" method="_on_HSlider_value_changed"]
    GDSC         %   �      ����������¶   ������Ѷ   ��Ѷ   ����������Ŷ   ���������޶�   ������������¶��   ����¶��   ��������������������ض��   ������Ҷ   �����϶�   ������Ӷ   �������׶���   �����������Ӷ���   ����   ����������������Ӷ��   ���ݶ���   �������Ŷ���   �����׶�   ��Ŷ   �����������������������ض���   �嶶   ��������������Ӷ   ߶��   ܶ��   ������������   ������������������������Ҷ��   ����Ӷ��                       �     h     �                                  
                     	      
         %      +      /      2      6      7      =      E      M      V      \      ]      d      h      |      �      �      �      �      �      �       �   !   �   "   �   #   �   $   �   %   3YY;�  YY;�  YY8;�  V�  Y8;�  V�  YY0�  P�  QV�  &�  4�  V�  &�  T�  V�  �  �  (V�  �  �  YY0�	  PQV�  �  �
  T�  PQ�  �
  �  T�  PQ�  �
  T�  P�  R�  Q�  �  T�  PQ�  Y0�  P�  QV�  &�  V�  ;�  �  PQ�  P�  R�  Q�  T�  PQ�  �?  P�  Q�  )�  �K  P�  R�  QV�  )�  �K  P�  R�  QV�  &P�  �  �  �  
�  QV�  �  T�  P�  �  P�  R�  QR�S  P�  R�  R�  R�  QQ�  �  �
  T�  P�  R�  QYYY0�  P�  QV�  �  �  Y`   [remap]

path="res://scene/CloudRect.gdc"
      [remap]

path="res://scene/Clouds.gdc"
         [remap]

path="res://scene/Grass.gdc"
          [remap]

path="res://scene/Light2D.gdc"
        [remap]

path="res://scripts/GrassPatch.gdc"
   �PNG

   IHDR   �   �   �>a�   sRGB ���  �IDATx��y|T����̒�$�L��F��������bEo�R���^�z�j�����~�WkUz�z�ꯥ�U�r��,.��(;� !�B�/3�d�s�2��d2�I&8�����y�3�s�y��Y^�a�[z3]2m�y�b�j�h[!ظ$I�� �]#L�$	A8�M�Z���2�}�(��h�r*vo���o�R
r��Z-�
e��H��Bt��&�HHz����	�L^_Z����������@%�)�)�2A�ֆ�  D��V�P��d�u����z)�F�U�!Ym�"Ԋ��vg�I�����ՂL��ܳ��o.0�[��@\$�Hq�� ��� �� w=�/X-f�$�f#��f�(#A��&�6c;X�٠8 f�jbb#24��� �ΕQD��B��}�	�S�� H�Ԣ�,�{��=G> t�����6Eh�6���+#P�$�!�P��L�r^�d� ���m� �z d �3/!->�� |ǹ�BIDdLx�7�RH�,f��I���(�G��'����)V�x���"�bǾ�a������8����}R>�(�	*�#��_E��1���0A@� �����H�8A���W*@Z�RA~�_D��R���#�Q�+b�V�R@��E��oG��	�R�(����O�_)"r�sA�B9�36x���M�`���r�:��xp[�&M%�E��0'�c+	B�R�K!��}(�E���JI��h/��/V��V@��ǩ/G����0��3�YP���Slر����Q]79A��+�b��\������r����d����0c�Z��DT\�ʆ��Ҹb����#��~�l6�~}�uon���gD�N����w�f�esE�W��b�ȩ
����ˣ���k�����-.�N TJ��r�,���)>����~�����:���ng���T������x;�<J��4�vƚ	+ �ӓ�u��Zz	ё�-�u���l��l6I���: ���w����|j++5��/��y��益�9YZ.�M`RB��z�>~q���x��-^ˌ7��:@J����_���7[9P�΁�v��u�������`��x�2?�uO�����=��p�њ��vp�����">JɼIq,�M`qN*��lt���W^��+����r�y���F��YRά_;�P��K�x���kY2�e���}��u/�(����z1��u�\?+���Tv}}�.]��eg���=�"�ט��4�zW�2��T���eY+k���Dj��X���Tzr�I	|��1?�:x��]�?�����{۷�I_���ڮr^�]I�9f�4d�6���T�q����6&���Y��o%o�]hT���p����V��s:�o����B$+>A���BIU=uM�#����. !��s�?z�>��a��z���#{����I�ʲ��?9��e�'�s��v�A�$���fDm���٭�y�Îs������p1��~A*Z��h��$A���7�ۉ��$=9�Ɩvz�}�w�JG��*ڨl��רS_C}a-��[���������UK��%�{���$�����ݞs_��!	�O��w�ǋQ��^��˞Rߧe{J[�mZY
�:�C(2a� ��b����+�&��e��l��h��� @F��H��BF�V��#������P�� ��B�(> ��V��=>.�8���B���t;��cF�Kb\� a�}`t��ƹ������ 8�ڍVK��:���x3&:@vf
ٙ�t��9z�ҧ:
�x�Վ��� c�s_�c5�^GNU�Tw��\�1�Tן���9X]t�_5B�็��ʅ3]��>T̺7�����^�:���\��˖��o���E������=� �?���x�z��##%��ﺉ���r9���I�\�&F��k��4[��?���y����떠�Pr���eЈ�7)�??� �fMu�������e��uM@�5�+o�����,-��N*�s�X~�|�,��{p�Q�Rr�w��3�AnV�ǵ&�'3%=�O�>����1����\�������#y)v�C�Ld��nX���nuM,�d&�~�����(~Y��/�?AI�ȼyB���^>9�L�V���D�Yy�B���Q���ʫ���w�d�td�AulǉF���0r< ٙ�(r���_�p���^į��g���#g����~^r4\���tנ�ʺ&r'J��;ΰ��7�P��$���H�����9��.�J�yuW9�m�^������k���G�w��������G���݁�6^���a��5���s4v����A����.��Wĩ�n��j�u��������h�O�bc���F���r��y��S˱�N�Ɍ�`ɼ�/��������������7"U��ª=Om.�j��n�e�	�#��T�C`��v��"��G����]���Oѐ�����,V�;x��><My�Σ��lgQvqQJd�ȕ�l�^�_�� ���KO���t��]o����鿰�j�I����3-$k"8Z���w��h��os�`�������9z#��r�}�mXl�u[l��Y:-�n�P*���Ň�"�a"� �q�����o:A}�o+`z��ݥ������?����5�.mEo�-���d����兩��@Jb�~'J�G�~�=��3Sn[ ����:3:ʛu����q|�m�&;�#�ۈ� �d"����P*��\iSԍ�Sa���@���J��g��{.�GU��y�r�����;�`����'l��;�`:�'M���_n^6�k�- ��ܽf��x��U�w����b�����_V9��^���X����- jU�#�����G�v�86�����-��P��O�spsw�7B�$�y �[ �������T.�KH���ey�,+\Fv��� �k�d�GǏ,/ .2�`*��E*ydy��x�G8�����>Ͽ���x�Z��+
��f�<����sx������4��J z����k�:B��$8�1���g��8��$I�y�]z�F��Z	<|���;�8��&�a�8Ҵj�&�q�q���@@f������s �2~z�4����P����i�<U��x�����v .b�Xy���v�w�Ȉ廋&��a��.�Č����om�x�C������V�������;.���0��Rȸ�)���7���:p�n�
��?v���,#R�\&��3 
3�c�K�05ECVB$�}�7�(o�Q��3�},����c�Oѐ��!3>���}�5�h�q���o�(�����������+�]� �lF����.G�?d�G����䧸�$?E�5��&��V=�o/��m|/�$F����d'����h��{_˛u�~{	gGi+��l�,��R�eL�HqH�H�ea�޹�c���N��;����~��^:�W�X�1���hx��ܲ0k�r�A�B�ܓ+��u���hi�×��^OYiˠ�B&r��٬��[��@�z^w]���I�-e�e����E�r?Z��u��OB&�*Q�2��í�a�F�M��=������ ��9��?Gɑ��U��+s�G��7��L�ǹ��tn��6n�����]�Ǳ�ΐ�t
��Ї�M%*bP�f3O<�3^z�e��8Sr��~����]S~t���I�V�Ng��t�4#3�>���1�����c?y�e�y饗y��a6:�FE�yh�TB�� �B���x�s����C�Yoûسg/ �2�>������,�����uSy������i1j�2� �ݻ���NA{��!��m�˹���!3E	�M�v$f���c���|����uX��E��d�<c~pe�� �2�W�P�a�Zy��u>�ٸ�=���:�EA �Ǿ�� ��+..��e�[otuuQ[k��-H�m��t/�
o�1�Fmm-]]��,��l�p9竰����h�opy�o����㢂�0��H�XQ����ǋ���V�iS�f�5 w��"�^'�1Ц����X��BB *�2rN-��<u��|���QP0�YG�T�l���<^�� 4t���&5w�\}�1�7o.��ɘ,�1Y�i��d����ļys}�����ܹ�e{�Bą>$@��7�ͣ?yt�zj���~� o];&�!�M����J�c?}�zx��'�=Jt�������	 �r��N��/�t1O��I����fdd���'--�Ҧ6:�\0�t�,�M=������'#��RtTTO��I/�z���.�k��K�,����ܱ����lٵ̝;���wPVZJ[[���̘1���V�R��5ZxaGɘ���$�v����-�������۷m������ד���ԂV�ZIB U��`�ŝg����R���Ͽ�?ȏ�+p�$&&r�]wz-���u���x]��EX����N���_W���x�ܲ�5���`��+���'�t�'ۗ���  t��yf�I����M�3�O�x��/oֱ������m�V�����I�FJ���/�?����X5'�Ä-I��:�m`WI�s��C�	� �J�?Z^J4�)*���7�F�@��Y9�1*ǀ�7�xu���;���Y܄�����My����И�E�
�3������z�}��8���3��5�(�@	2&� �@�D&d��aƇ� |�	�7��� �S�����>�:#�~3��1���w�a2ۨ���j��g���";1
�L`r|J�Hf\$j���X��dM�A�� �ܼ���J�>܄M���U4�h�����>��U�#��07���#Y���x2� Q��Scլ��t<�5j�Y������IP�益H�U���LN�B&�w�.�`f�o���HӪy��BG{�Rբ�[O��r��=$׬j�c�$j�z1Ym4w��ܭs�j��* ��[�_���hD�$D���,�I��\�`4����%Y�|���h��,��2��;����6T�c�بi��f�3(B\=}�??��J_���������]�Gs-�{�q��U޷�/. �fYg�O&��2���g����U����9	ܹ$��Z#A���(��(�ο��GO�p����<��P���x�tWsi�Z1�khTr� �����Trw.�F%G�?�tTq���^#{��O^L����sJ���|����g�߽�?o�������8��s�d��)�V+���k�z��B�̀��`���g��w:�LL�緵ɈSsf�ͫ2����M��#����|!U��Sw����ӕu\6w ����-kQ}�U��lu�nݲ0�k\��&9�>����v��\��Gc�k�48o.�O"]�v��8���l�t(�f밂덁8D����&�p�Tw�b�">7K;Li�T��=vsG&
.k	s�⼖kE�xCנ ,�Kd�(��V�2��}"-�;���j0��}�����9r!x��rV�Sެ����h�EFh��7Sެ�`U;�|:�����u��~#'�k��1r�0��l�}�[W\�wdr�޷ ��Z��js����	Q(�Kt�Z!sl���T:b�㣔��ӱ�x��u|e[Q#���H���Ǟ��Ug��NQ��瘡T��If�Dm{`����g�e�!L���E���q�^nY~9� �$/������x���-;|��>��_��d���ƼIq�O��fc��=������3�6���u���/i^L�2~�|0>򓯎S�42e�W�6*����ykj��_�4eX�E)yju!����l���׿���6"�=z^Z��q�`J<��yV�M0r�߮�ł)��/��}�z��0���*ꚰZm,�i�N�U333��e�!��3TP)d<{�lf;Mg�k�66}�/������+��h2�h�=�>%F��,-���7_��Ďm��߮�Ea�����o}��[>x[c.  E����X2w: Iߞ���b����#}&*� 7����3Iw�5���a�9. p����nW�/��#Y�����Dj�zi�ĉcEaF,�|g���(ǿ{���q`_�Ό�  �T�����¼�h5�v⢔���F�VEu�~�;�����vM�KR���f~��Mv�/
j�� �X������}����p5?\s�Ǧ���]|T��޲֋f+���U�,���b�{
�76}Ļ�v�j�7_��lq9 9A�#߿�k/�̵�g���L�<G�0f�Pezz�SY:-�a9t擯����-�vt�Y�BJ �7#����rłB����^#�z8��M��N�[C3�$;)��Yqv�AF�Q�� �6{���m_p����U�KH
� q1Ѭ\z	��YLvf���-�n��TC7�z:�L����"/9m����h��h(索�sl�� �v���p�� 83k�dn�z1�^:��h�ܱ��F:zMT4���3Ӣ�G�����p��o��m�ݴXQn^�y��5*��
�R4�G)}��٭���El��`PL��0a������g��L�&9�?G�`���ŉ�j����Pq5-�Wc&� ���ǜ�fO�&;#���)�d���f:�uT74St���3գ��w��(�B�''��Ր;)���8�b����L�r1Qj2R\ݻ�ϵ��su;SUHt��r���ʺFڻ�4��Vp�Hp�q�
$�-�4��S\V3�]�0����$�a��0c���JH:�V�B��[O<�VhIr�(H���I&�p[A�ZDI\➭�o�U��J�P*"�k���Q��x���f���c��"h�Y����놙�XL��l�� 	IW�t|���UA��\�l��."$I�lp���I�T������g~J�$�*��f��71M�a<1���>��d0���U�"V��dr�Axù��d�d�l�a��d�c1�)����(��+vo��<y)�jz~�f;��+#PF�x���H�����c�%8QRް�v�������k��f�a�$�0d11��c1�3kO,F�}��_��l6��ת���{;2�+H̙�#�����D;״�MXL$��$� ӱZ�HV+c�>�}�=�}i���j��a��y��z��۱Z��"Ԋ�0	N�����.�x�;jO�vJ�٦��I�1	�0�lOa�	��k%���7{����Y���j5?l6�J�����L$$�$�͆�V��a����z0�j���f�dڬ=�BŤ�6ѶB�qH"�4#<=g$IBN�`�D�m�G��u$�b,Z���ݞO�3�m�߷P5�:    IEND�B`�      ECFG      _global_script_classes             _global_script_class_icons             application/config/name         Grass Shader   application/run/main_scene          res://scene/Main.tscn      application/config/icon         res://icon.png     display/window/size/width      �     display/window/size/height      h     display/window/stretch/mode         viewport   display/window/stretch/aspect         expand  $   rendering/quality/driver/driver_name         GLES2   %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2          )   rendering/environment/default_clear_color      ��?��@?��?  �?)   rendering/environment/default_environment          res://default_env.tres      