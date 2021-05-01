// Kontakt Sample Library Tools
// Written by: Yaron Eshkar
// Modified: April 26, 2021
///////////////////////////////

// Performance - Disables FES
p5.disableFriendlyErrors = true; 

///////////////////////// Global Variables///////////////////////////////////////

var link_to_sox = "https://sourceforge.net/projects/sox/files/sox/";
var link_to_flac = "https://xiph.org/flac/download.html";
var link_to_doc = "http://faxinadu.net/jstest/ctlua/doc/";
var link_to_framework = "http://www.faxinadu.net/jstest/ctlua/framework/creator-tools-lua-framework-260421.zip";


var text_interval_x = 50;
var text_interval_x_2 = text_interval_x*7;
var text_interval_x_3 = text_interval_x*13;
var text_interval_x_4 = text_interval_x*19;
var text_interval_y = 30;
var text_box_size_y = 25;

var button_color_off = "#152902";
var button_color_on = "#5fb50d";
var button_corner_radius = 0;
var button_size_x = 25;
var button_size_y = 15;

var button_interval_x = 150;
var button_interval_y = 30;

var slider_interval_x = 150;
var slider_interval_y = 30;
var slider_width = "100px";
var slider_button_offset = 35;
var slider_text_offset = 115;

var get_sox_button;
var get_flac_button;

var sox_path_mac_input;
var sox_path_win_input;

var flac_path_mac_input;
var flac_path_win_input;

var download_framework_button;
var documentation_button;
var source_code_button;

var samples_path_button;
	var sample_path_bool;
var verbose_mode_button;
	var verbose_mode_bool = false;
var export_button;
	var export_bool;

var ksp_script_set_button;
	var ksp_script_set_bool = false;
var ksp_script_path_button;
	var ksp_script_path_bool = false;
var ksp_script_linked_button;
	var ksp_script_linked_bool = false;
var ksp_script_bypass_button;
	var ksp_script_bypass_bool = false;

var auto_mapper_set_button;
	var auto_mapper_set_bool = false;
var reset_groups_button;
	var reset_groups_bool = false;
var root_detect_button;
	var root_detect_bool = false;
var fix_tune_button;
	var fix_tune_bool = false;
var key_confine_button;
	var key_confine_bool = false;
var vel_confine_button;
	var vel_confine_bool = false;

var audio_tools_button;
	var audio_tools_bool = false;
var decode_flac_button;
	var decode_flac_bool = false;
var hp_filter_button;
	var hp_filter_bool = false;
var normalise_button;
	var normalise_bool = false;
var reverse_button;
	var reverse_bool = false;
var silence_button;
	var silence_bool = false;
var convert_sr_button;
	var convert_sr_bool = false;
var convert_bd_button;
	var convert_bd_bool = false;
var encode_ncw_button;
	var encode_ncw_bool = false;
var encode_flac_button;
	var encode_flac_bool = false;
var encode_ogg_button;
	var encode_ogg_bool = false;

var sample_set_integrity_button;
	var sample_set_integrity_bool = false;
var rms_check_button;
	var rms_check_bool = false;
var loudness_check_button;
	var loudness_check_bool = false;
var peak_check_button;
	var peak_check_bool = false;
var sample_rate_check_button;
	var sample_rate_check_bool = false;
var bit_depth_check_button;
	var bit_depth_check_bool = false;
var file_size_check_button;
	var file_size_check_bool = false;
var loop_exists_button;
	var loop_exists_bool = false;
var file_names_check_button;
	var file_names_check_bool = false;

var samples_path_input;

var ksp_script_path_input;
var ksp_script_name_input;

var file_size_input;

var root_key_location_slider;
var low_key_location_slider;
var high_key_location_slider;
var low_vel_location_slider;
var high_vel_location_slider;
var sample_name_location_slider;
var signal_name_location_slider;
var articulation_location_slider;
var round_robin_location_slider;
var default_root_key_value_slider;
var default_low_key_value_slider;
var default_high_key_value_slider;
var default_low_vel_value_slider;
var default_high_vel_value_slider;
var loop_xfade_slider;

var hp_filter_slider;
var normalise_db_slider;

var rms_check_slider;
var loudness_check_slider;
var peak_check_slider;

var playback_mode_select;
var set_loop_select;
var token_separator_select;

var ksp_script_slot_select;

var convert_sr_select;
var convert_bd_select;

var sr_check_select;
var bd_check_select;

var parameter_array = [];

var load_prest_file;

/////////////////////////////////////////////////////////////////////////////////////////////

// Preload Function
function preload() { 

} // End Preload

/////////////////////////////////////////////////////////////////////////////////////////////

// Setup Function
function setup() {

	var canvasX = windowWidth;
	var canvasY = 2500;

	load_prest_file = createFileInput(handle_preset_file);
	load_prest_file.position(button_interval_x*5,button_interval_y*2);

	playback_mode_select = createSelect();
		playback_mode_select.position(button_interval_x*3,button_interval_y*10);
		playback_mode_select.option("sampler");
		playback_mode_select.option("tone_machine");
		playback_mode_select.option("wavetable");
		playback_mode_select.option("time_machine");
		playback_mode_select.option("dfd");
		playback_mode_select.option("beat_machine");
		playback_mode_select.option("time_machine_2");
		playback_mode_select.option("s1200");
		playback_mode_select.option("mpc60");
		playback_mode_select.option("time_machine_pro");
		playback_mode_select.selected("dfd");

	token_separator_select = createSelect();
		token_separator_select.position(button_interval_x*3,button_interval_y*11);
		token_separator_select.option("-");
		token_separator_select.option("_");
		token_separator_select.selected("-");	
		
	set_loop_select = createSelect();
		set_loop_select.position(button_interval_x*3,button_interval_y*17);
		set_loop_select.option("Off");
		set_loop_select.option("Just Set");
		set_loop_select.option("From Sample");
		set_loop_select.option("Find Loop");
		set_loop_select.selected("Off");		

	ksp_script_slot_select = createSelect();
		ksp_script_slot_select.position(button_interval_x*3.25,button_interval_y*6);
		ksp_script_slot_select.option("0");
		ksp_script_slot_select.option("1");
		ksp_script_slot_select.option("2");
		ksp_script_slot_select.option("3");
		ksp_script_slot_select.option("4");
		ksp_script_slot_select.selected("0");		

	convert_sr_select = createSelect();
		convert_sr_select.position((button_interval_x*5)+slider_button_offset,button_interval_y*13);
		convert_sr_select.option("44100");
		convert_sr_select.option("48000");
		convert_sr_select.option("88000");
		convert_sr_select.option("96000");
		convert_sr_select.selected("44100");	

	convert_bd_select = createSelect();
		convert_bd_select.position((button_interval_x*5)+slider_button_offset,button_interval_y*14);
		convert_bd_select.option("16");
		convert_bd_select.option("24");
		convert_bd_select.selected("16");		

	sr_check_select = createSelect();
			sr_check_select.position((button_interval_x*7)+slider_button_offset,button_interval_y*11);
			sr_check_select.option("44100");
			sr_check_select.option("48000");
			sr_check_select.option("88000");
			sr_check_select.option("96000");
			sr_check_select.selected("44100");	

	bd_check_select = createSelect();
			bd_check_select.position((button_interval_x*7)+slider_button_offset,button_interval_y*12);
			bd_check_select.option("16");
			bd_check_select.option("24");
			bd_check_select.selected("16");	

	get_sox_button = new Clickable();
		get_sox_button.color = button_color_off;
		get_sox_button.text = "";
		get_sox_button.cornerRadius = button_corner_radius;
		get_sox_button.resize(button_size_x,button_size_y);
		get_sox_button.onPress = function () {
			window.open(link_to_sox,"_blank");
		}

	get_flac_button = new Clickable();
		get_flac_button.color = button_color_off;
		get_flac_button.text = "";
		get_flac_button.cornerRadius = button_corner_radius;
		get_flac_button.resize(button_size_x,button_size_y);
		get_flac_button.onPress = function () {
			window.open(link_to_flac,"_blank");
		}

	download_framework_button = new Clickable();
		download_framework_button.color = button_color_off;
		download_framework_button.text = "";
		download_framework_button.cornerRadius = button_corner_radius;
		download_framework_button.resize(button_size_x,button_size_y);
		download_framework_button.onPress = function () {
			window.open(link_to_framework,"_blank");
		}

	documentation_button = new Clickable();
		documentation_button.color = button_color_off;
		documentation_button.text = "";
		documentation_button.cornerRadius = button_corner_radius;
		documentation_button.resize(button_size_x,button_size_y);
		documentation_button.onPress = function () {
			window.open(link_to_doc,"_blank");
		}

	samples_path_button = new Clickable();
		samples_path_button.color = button_color_off;
		samples_path_button.text = "";
		samples_path_button.cornerRadius = button_corner_radius;
		samples_path_button.resize(button_size_x,button_size_y);
		samples_path_button.onPress = function () {
			if (sample_path_bool) {
				this.color = button_color_off;
				sample_path_bool = false;
			} else {
				this.color = button_color_on;
				sample_path_bool = true;
			}		
		}

	verbose_mode_button = new Clickable();
		verbose_mode_button.color = button_color_off;
		verbose_mode_button.text = "";
		verbose_mode_button.cornerRadius = button_corner_radius;
		verbose_mode_button.resize(button_size_x,button_size_y);    
		verbose_mode_button.onPress = function () {
			if (verbose_mode_bool) {
				this.color = button_color_off;
				verbose_mode_bool = false;
			} else {
				this.color = button_color_on;
				verbose_mode_bool = true;
			}
		}    

	export_button = new Clickable();
		export_button.color = button_color_off;
		export_button.text = "";
		export_button.cornerRadius = button_corner_radius;
		export_button.resize(button_size_x,button_size_y);    
		export_button.onPress = function () {
			if (export_bool) {
				this.color = button_color_off;
				export_bool = false;
			} else {
				this.color = button_color_on;
				export_variables();
				export_bool = true;
				sleep(100).then(() => {this.color = button_color_off;})
				
			}
		}    

	ksp_script_set_button = new Clickable();
		ksp_script_set_button.color = button_color_off;
		ksp_script_set_button.text = "";
		ksp_script_set_button.cornerRadius = button_corner_radius;
		ksp_script_set_button.resize(button_size_x,button_size_y);    
		ksp_script_set_button.onPress = function () {
			if (ksp_script_set_bool) {
				this.color = button_color_off;
				ksp_script_set_bool = false;
			} else {
				this.color = button_color_on;
				ksp_script_set_bool = true;
			}
		}    

	ksp_script_path_button = new Clickable();
		ksp_script_path_button.color = button_color_off;
		ksp_script_path_button.text = "";
		ksp_script_path_button.cornerRadius = button_corner_radius;
		ksp_script_path_button.resize(button_size_x,button_size_y); 
		ksp_script_path_button.onPress = function () {
			if (ksp_script_path_bool) {
				this.color = button_color_off;
				ksp_script_path_bool = false;
			} else {
				this.color = button_color_on;
				ksp_script_path_bool = true;
			}
		}      

	ksp_script_linked_button = new Clickable();
		ksp_script_linked_button.color = button_color_off;
		ksp_script_linked_button.text = "";
		ksp_script_linked_button.cornerRadius = button_corner_radius;
		ksp_script_linked_button.resize(button_size_x,button_size_y);    
		ksp_script_linked_button.onPress = function () {
			if (ksp_script_linked_bool) {
				this.color = button_color_off;
				ksp_script_linked_bool = false;
			} else {
				this.color = button_color_on;
				ksp_script_linked_bool = true;
			}
		}      
		
	ksp_script_bypass_button = new Clickable();
		ksp_script_bypass_button.color = button_color_off;
		ksp_script_bypass_button.text = "";
		ksp_script_bypass_button.cornerRadius = button_corner_radius;
		ksp_script_bypass_button.resize(button_size_x,button_size_y);
		ksp_script_bypass_button.onPress = function () {
			if (ksp_script_bypass_bool) {
				this.color = button_color_off;
				ksp_script_bypass_bool = false;
			} else {
				this.color = button_color_on;
				ksp_script_bypass_bool = true;
			}
		}      

	auto_mapper_set_button = new Clickable();
		auto_mapper_set_button.color = button_color_off;
		auto_mapper_set_button.text = "";
		auto_mapper_set_button.cornerRadius = button_corner_radius;
		auto_mapper_set_button.resize(button_size_x,button_size_y);
		auto_mapper_set_button.onPress = function () {
			if (auto_mapper_set_bool) {
				this.color = button_color_off;
				auto_mapper_set_bool = false;
			} else {
				this.color = button_color_on;
				auto_mapper_set_bool = true;
			}
		}    

	reset_groups_button = new Clickable();
		reset_groups_button.color = button_color_off;
		reset_groups_button.text = "";
		reset_groups_button.cornerRadius = button_corner_radius;
		reset_groups_button.resize(button_size_x,button_size_y);
		reset_groups_button.onPress = function () {
			if (reset_groups_bool) {
				this.color = button_color_off;
				reset_groups_bool = false;
			} else {
				this.color = button_color_on;
				reset_groups_bool = true;
			}
		}   

	root_detect_button = new Clickable();
		root_detect_button.color = button_color_off;
		root_detect_button.text = "";
		root_detect_button.cornerRadius = button_corner_radius;
		root_detect_button.resize(button_size_x,button_size_y);
		root_detect_button.onPress = function () {
			if (root_detect_bool) {
				this.color = button_color_off;
				root_detect_bool = false;
			} else {
				this.color = button_color_on;
				root_detect_bool = true;
			}
		}   

	fix_tune_button = new Clickable();
		fix_tune_button.color = button_color_off;
		fix_tune_button.text = "";
		fix_tune_button.cornerRadius = button_corner_radius;
		fix_tune_button.resize(button_size_x,button_size_y);
		fix_tune_button.onPress = function () {
			if (fix_tune_bool) {
				this.color = button_color_off;
				fix_tune_bool = false;
			} else {
				this.color = button_color_on;
				fix_tune_bool = true;
			}
		}   

	key_confine_button = new Clickable();
		key_confine_button.color = button_color_off;
		key_confine_button.text = "";
		key_confine_button.cornerRadius = button_corner_radius;
		key_confine_button.resize(button_size_x,button_size_y);
		key_confine_button.onPress = function () {
			if (key_confine_bool) {
				this.color = button_color_off;
				key_confine_bool = false;
			} else {
				this.color = button_color_on;
				key_confine_bool = true;
			}
		}   

	vel_confine_button = new Clickable();
		vel_confine_button.color = button_color_off;
		vel_confine_button.text = "";
		vel_confine_button.cornerRadius = button_corner_radius;
		vel_confine_button.resize(button_size_x,button_size_y);
		vel_confine_button.onPress = function () {
			if (vel_confine_bool) {
				this.color = button_color_off;
				vel_confine_bool = false;
			} else {
				this.color = button_color_on;
				vel_confine_bool = true;
			}
		}  

	audio_tools_button = new Clickable();
		audio_tools_button.color = button_color_off;
		audio_tools_button.text = "";
		audio_tools_button.cornerRadius = button_corner_radius;
		audio_tools_button.resize(button_size_x,button_size_y);
		audio_tools_button.onPress = function () {
			if (audio_tools_bool) {
				this.color = button_color_off;
				audio_tools_bool = false;
			} else {
				this.color = button_color_on;
				audio_tools_bool = true;
			}
		}  

	decode_flac_button = new Clickable();
		decode_flac_button.color = button_color_off;
		decode_flac_button.text = "";
		decode_flac_button.cornerRadius = button_corner_radius;
		decode_flac_button.resize(button_size_x,button_size_y);
		decode_flac_button.onPress = function () {
			if (decode_flac_bool) {
				this.color = button_color_off;
				decode_flac_bool = false;
			} else {
				this.color = button_color_on;
				decode_flac_bool = true;
			}
		}  

	hp_filter_button = new Clickable();
		hp_filter_button.color = button_color_off;
		hp_filter_button.text = "";
		hp_filter_button.cornerRadius = button_corner_radius;
		hp_filter_button.resize(button_size_x,button_size_y);
		hp_filter_button.onPress = function () {
			if (hp_filter_bool) {
				this.color = button_color_off;
				hp_filter_bool = false;
			} else {
				this.color = button_color_on;
				hp_filter_bool = true;
			}
		}  

	normalise_button = new Clickable();
		normalise_button.color = button_color_off;
		normalise_button.text = "";
		normalise_button.cornerRadius = button_corner_radius;
		normalise_button.resize(button_size_x,button_size_y);
		normalise_button.onPress = function () {
			if (normalise_bool) {
				this.color = button_color_off;
				normalise_bool = false;
			} else {
				this.color = button_color_on;
				normalise_bool = true;
			}
		}  

	reverse_button = new Clickable();
		reverse_button.color = button_color_off;
		reverse_button.text = "";
		reverse_button.cornerRadius = button_corner_radius;
		reverse_button.resize(button_size_x,button_size_y);
		reverse_button.onPress = function () {
			if (reverse_bool) {
				this.color = button_color_off;
				reverse_bool = false;
			} else {
				this.color = button_color_on;
				reverse_bool = true;
			}
		}  

	silence_button = new Clickable();
		silence_button.color = button_color_off;
		silence_button.text = "";
		silence_button.cornerRadius = button_corner_radius;
		silence_button.resize(button_size_x,button_size_y);
		silence_button.onPress = function () {
			if (silence_bool) {
				this.color = button_color_off;
				silence_bool = false;
			} else {
				this.color = button_color_on;
				silence_bool = true;
			}
		}  

	convert_sr_button = new Clickable();
		convert_sr_button.color = button_color_off;
		convert_sr_button.text = "";
		convert_sr_button.cornerRadius = button_corner_radius;
		convert_sr_button.resize(button_size_x,button_size_y);
		convert_sr_button.onPress = function () {
			if (convert_sr_bool) {
				this.color = button_color_off;
				convert_sr_bool = false;
			} else {
				this.color = button_color_on;
				convert_sr_bool = true;
			}
		}  

	convert_bd_button = new Clickable();
		convert_bd_button.color = button_color_off;
		convert_bd_button.text = "";
		convert_bd_button.cornerRadius = button_corner_radius;
		convert_bd_button.resize(button_size_x,button_size_y);
		convert_bd_button.onPress = function () {
			if (convert_bd_bool) {
				this.color = button_color_off;
				convert_bd_bool = false;
			} else {
				this.color = button_color_on;
				convert_bd_bool = true;
			}
		}  

	encode_ncw_button = new Clickable();
		encode_ncw_button.color = button_color_off;
		encode_ncw_button.text = "";
		encode_ncw_button.cornerRadius = button_corner_radius;
		encode_ncw_button.resize(button_size_x,button_size_y);
		encode_ncw_button.onPress = function () {
			if (encode_ncw_bool) {
				this.color = button_color_off;
				encode_ncw_bool = false;
			} else {
				this.color = button_color_on;
				encode_ncw_bool = true;
			}
		}  

	encode_flac_button = new Clickable();
		encode_flac_button.color = button_color_off;
		encode_flac_button.text = "";
		encode_flac_button.cornerRadius = button_corner_radius;
		encode_flac_button.resize(button_size_x,button_size_y);
		encode_flac_button.onPress = function () {
			if (encode_flac_bool) {
				this.color = button_color_off;
				encode_flac_bool = false;
			} else {
				this.color = button_color_on;
				encode_flac_bool = true;
			}
		}  
		
	encode_ogg_button = new Clickable();
		encode_ogg_button.color = button_color_off;
		encode_ogg_button.text = "";
		encode_ogg_button.cornerRadius = button_corner_radius;
		encode_ogg_button.resize(button_size_x,button_size_y);
		encode_ogg_button.onPress = function () {
			if (encode_ogg_bool) {
				this.color = button_color_off;
				encode_ogg_bool = false;
			} else {
				this.color = button_color_on;
				encode_ogg_bool = true;
			}
		}  

	sample_set_integrity_button = new Clickable();
		sample_set_integrity_button.color = button_color_off;
		sample_set_integrity_button.text = "";
		sample_set_integrity_button.cornerRadius = button_corner_radius;
		sample_set_integrity_button.resize(button_size_x,button_size_y);
		sample_set_integrity_button.onPress = function () {
			if (sample_set_integrity_bool) {
				this.color = button_color_off;
				sample_set_integrity_bool = false;
			} else {
				this.color = button_color_on;
				sample_set_integrity_bool = true;
			}
		}  

	rms_check_button = new Clickable();
		rms_check_button.color = button_color_off;
		rms_check_button.text = "";
		rms_check_button.cornerRadius = button_corner_radius;
		rms_check_button.resize(button_size_x,button_size_y);
		rms_check_button.onPress = function () {
			if (rms_check_bool) {
				this.color = button_color_off;
				rms_check_bool = false;
			} else {
				this.color = button_color_on;
				rms_check_bool = true;
			}
		}  

	loudness_check_button = new Clickable();
		loudness_check_button.color = button_color_off;
		loudness_check_button.text = "";
		loudness_check_button.cornerRadius = button_corner_radius;
		loudness_check_button.resize(button_size_x,button_size_y);
		loudness_check_button.onPress = function () {
			if (loudness_check_bool) {
				this.color = button_color_off;
				loudness_check_bool = false;
			} else {
				this.color = button_color_on;
				loudness_check_bool = true;
			}
		}  

	peak_check_button = new Clickable();
		peak_check_button.color = button_color_off;
		peak_check_button.text = "";
		peak_check_button.cornerRadius = button_corner_radius;
		peak_check_button.resize(button_size_x,button_size_y);
		peak_check_button.onPress = function () {
			if (peak_check_bool) {
				this.color = button_color_off;
				peak_check_bool = false;
			} else {
				this.color = button_color_on;
				peak_check_bool = true;
			}
		}  

	sample_rate_check_button = new Clickable();
		sample_rate_check_button.color = button_color_off;
		sample_rate_check_button.text = "";
		sample_rate_check_button.cornerRadius = button_corner_radius;
		sample_rate_check_button.resize(button_size_x,button_size_y);
		sample_rate_check_button.onPress = function () {
			if (sample_rate_check_bool) {
				this.color = button_color_off;
				sample_rate_check_bool = false;
			} else {
				this.color = button_color_on;
				sample_rate_check_bool = true;
			}
		}  

	bit_depth_check_button = new Clickable();
		bit_depth_check_button.color = button_color_off;
		bit_depth_check_button.text = "";
		bit_depth_check_button.cornerRadius = button_corner_radius;
		bit_depth_check_button.resize(button_size_x,button_size_y);
		bit_depth_check_button.onPress = function () {
			if (bit_depth_check_bool) {
				this.color = button_color_off;
				bit_depth_check_bool = false;
			} else {
				this.color = button_color_on;
				bit_depth_check_bool = true;
			}
		}  

	file_size_check_button = new Clickable();
		file_size_check_button.color = button_color_off;
		file_size_check_button.text = "";
		file_size_check_button.cornerRadius = button_corner_radius;
		file_size_check_button.resize(button_size_x,button_size_y);
		file_size_check_button.onPress = function () {
			if (file_size_check_bool) {
				this.color = button_color_off;
				file_size_check_bool = false;
			} else {
				this.color = button_color_on;
				file_size_check_bool = true;
			}
		}  

	loop_exists_button = new Clickable();
		loop_exists_button.color = button_color_off;
		loop_exists_button.text = "";
		loop_exists_button.cornerRadius = button_corner_radius;
		loop_exists_button.resize(button_size_x,button_size_y);
		loop_exists_button.onPress = function () {
			if (loop_exists_bool) {
				this.color = button_color_off;
				loop_exists_bool = false;
			} else {
				this.color = button_color_on;
				loop_exists_bool = true;
			}
		}  

	file_names_check_button = new Clickable();
		file_names_check_button.color = button_color_off;
		file_names_check_button.text = "";
		file_names_check_button.cornerRadius = button_corner_radius;
		file_names_check_button.resize(button_size_x,button_size_y);
		file_names_check_button.onPress = function () {
			if (file_names_check_bool) {
				this.color = button_color_off;
				file_names_check_bool = false;
			} else {
				this.color = button_color_on;
				file_names_check_bool = true;
			}
		}  

	root_key_location_slider = createSlider(-1,20,-1,1);
		root_key_location_slider.position(slider_interval_x, slider_interval_y*11);
		root_key_location_slider.style('width',slider_width);

	low_key_location_slider = createSlider(-1,20,-1,1);
		low_key_location_slider.position(slider_interval_x, slider_interval_y*12);
		low_key_location_slider.style('width',slider_width);

	high_key_location_slider = createSlider(-1,20,-1,1);
		high_key_location_slider.position(slider_interval_x, slider_interval_y*13);
		high_key_location_slider.style('width',slider_width);	
		
	low_vel_location_slider = createSlider(-1,20,-1,1);
		low_vel_location_slider.position(slider_interval_x, slider_interval_y*14);
		low_vel_location_slider.style('width',slider_width);

	high_vel_location_slider = createSlider(-1,20,-1,1);
		high_vel_location_slider.position(slider_interval_x, slider_interval_y*15);
		high_vel_location_slider.style('width',slider_width);

	sample_name_location_slider = createSlider(-1,20,-1,1);
		sample_name_location_slider.position(slider_interval_x, slider_interval_y*16);
		sample_name_location_slider.style('width',slider_width);

	signal_name_location_slider = createSlider(-1,20,-1,1);
		signal_name_location_slider.position(slider_interval_x, slider_interval_y*17);
		signal_name_location_slider.style('width',slider_width);

	articulation_location_slider = createSlider(-1,20,-1,1);
		articulation_location_slider.position(slider_interval_x, slider_interval_y*18);
		articulation_location_slider.style('width',slider_width);

	round_robin_location_slider = createSlider(-1,20,-1,1);
		round_robin_location_slider.position(slider_interval_x, slider_interval_y*19);
		round_robin_location_slider.style('width',slider_width);

	default_root_key_value_slider = createSlider(0,127,60,1);
		default_root_key_value_slider.position(slider_interval_x*3, slider_interval_y*12);
		default_root_key_value_slider.style('width',slider_width);

	default_low_key_value_slider = createSlider(0,127,0,1);
		default_low_key_value_slider.position(slider_interval_x*3, slider_interval_y*13);
		default_low_key_value_slider.style('width',slider_width);

	default_high_key_value_slider = createSlider(0,127,127,1);
		default_high_key_value_slider.position(slider_interval_x*3, slider_interval_y*14);
		default_high_key_value_slider.style('width',slider_width);

	default_low_vel_value_slider = createSlider(0,127,0,1);
		default_low_vel_value_slider.position(slider_interval_x*3, slider_interval_y*15);
		default_low_vel_value_slider.style('width',slider_width);

	default_high_vel_value_slider = createSlider(0,127,127,1);
		default_high_vel_value_slider.position(slider_interval_x*3, slider_interval_y*16);
		default_high_vel_value_slider.style('width',slider_width);

	loop_xfade_slider = createSlider(0,1000,20,1);
		loop_xfade_slider.position(slider_interval_x*3, slider_interval_y*18);
		loop_xfade_slider.style('width',slider_width);

	hp_filter_slider = createSlider(10,80,10,1);
		hp_filter_slider.position((slider_interval_x*5)+slider_button_offset, slider_interval_y*9);
		hp_filter_slider.style('width',slider_width);

	normalise_db_slider = createSlider(-10,-0.1,-0.1,0.1);
		normalise_db_slider.position((slider_interval_x*5)+slider_button_offset, slider_interval_y*10);
		normalise_db_slider.style('width',slider_width);

	rms_check_slider = createSlider(1,20,2,1);
		rms_check_slider.position((slider_interval_x*7)+slider_button_offset, slider_interval_y*8);
		rms_check_slider.style('width',slider_width);

	loudness_check_slider = createSlider(1,20,2,1);
		loudness_check_slider.position((slider_interval_x*7)+slider_button_offset, slider_interval_y*9);
		loudness_check_slider.style('width',slider_width);

	peak_check_slider = createSlider(1,20,2,1);
		peak_check_slider.position((slider_interval_x*7)+slider_button_offset, slider_interval_y*10);
		peak_check_slider.style('width',slider_width);

	// Create canvas 
	canvas = createCanvas(canvasX,canvasY); 
	background('#000000'); 

	// Send canvas to CSS class through HTML div
	canvas.parent('sketch-holder');

	// Set canvas framerate
	// frameRate(25);

	get_sox_button.locate(button_interval_x*5,15);
	get_flac_button.locate(button_interval_x*6.2,15);

	download_framework_button.locate(button_interval_x+25,button_interval_y*2);
	documentation_button.locate((button_interval_x*2)+25,button_interval_y*2);
	export_button.locate(button_interval_x*3.3,button_interval_y*2);

	samples_path_button.locate(button_interval_x,button_interval_y*3);
	verbose_mode_button.locate(button_interval_x*5,button_interval_y*3);
	
	ksp_script_set_button.locate(button_interval_x*1.5,button_interval_y*4);
	ksp_script_path_button.locate(button_interval_x,button_interval_y*5);
	ksp_script_linked_button.locate(button_interval_x*2,button_interval_y*6);
	ksp_script_bypass_button.locate(button_interval_x*2.75,button_interval_y*6);

	auto_mapper_set_button.locate(button_interval_x*1.5,button_interval_y*7);
	reset_groups_button.locate(button_interval_x,button_interval_y*8);
	root_detect_button.locate(button_interval_x,button_interval_y*9);
	fix_tune_button.locate(button_interval_x,button_interval_y*10);

	key_confine_button.locate(button_interval_x*3,button_interval_y*8);
	vel_confine_button.locate(button_interval_x*3,button_interval_y*9);

	audio_tools_button.locate(button_interval_x*5.2,button_interval_y*7);
	decode_flac_button.locate(button_interval_x*5,button_interval_y*8);
	hp_filter_button.locate(button_interval_x*5,button_interval_y*9);
	normalise_button.locate(button_interval_x*5,button_interval_y*10);
	reverse_button.locate(button_interval_x*5,button_interval_y*11);
	silence_button.locate(button_interval_x*5,button_interval_y*12);
	convert_sr_button.locate(button_interval_x*5,button_interval_y*13);
	convert_bd_button.locate(button_interval_x*5,button_interval_y*14);
	encode_ncw_button.locate(button_interval_x*5,button_interval_y*15);
	encode_flac_button.locate(button_interval_x*5,button_interval_y*16);
	encode_ogg_button.locate(button_interval_x*5,button_interval_y*17);

	sample_set_integrity_button.locate(button_interval_x*7.7,button_interval_y*7);
	rms_check_button.locate(button_interval_x*7,button_interval_y*8);
	loudness_check_button.locate(button_interval_x*7,button_interval_y*9);
	peak_check_button.locate(button_interval_x*7,button_interval_y*10);
	sample_rate_check_button.locate(button_interval_x*7,button_interval_y*11);
	bit_depth_check_button.locate(button_interval_x*7,button_interval_y*12);
	file_size_check_button.locate(button_interval_x*7,button_interval_y*13);
	loop_exists_button.locate(button_interval_x*7,button_interval_y*14);
	file_names_check_button.locate(button_interval_x*7,button_interval_y*15);

	sox_path_mac_input = createInput("/opt/homebrew/bin/sox");
		sox_path_mac_input.position(button_interval_x*7,button_interval_y*2);
		sox_path_mac_input.size(300);	

	sox_path_win_input = createInput("sox");
		sox_path_win_input.position(button_interval_x*7,button_interval_y*3);
		sox_path_win_input.size(300);	

	flac_path_mac_input = createInput("/opt/homebrew/bin/flac");
		flac_path_mac_input.position(button_interval_x*7,button_interval_y*4);
		flac_path_mac_input.size(300);	

	flac_path_win_input = createInput("flac");
		flac_path_win_input.position(button_interval_x*7,button_interval_y*5);
		flac_path_win_input.size(300);	

	samples_path_input = createInput("/Users/yaron.eshkar/Faxi/creator-tools-lua-framework/Samples");
		samples_path_input.position(button_interval_x+35,button_interval_y*3);
		samples_path_input.size(450);

	ksp_script_path_input = createInput("/Users/yaron.eshkar/Faxi/creator-tools-lua-framework/KSP/ksp_script.ksp");
		ksp_script_path_input.position(button_interval_x+35,button_interval_y*5);
		ksp_script_path_input.size(450);

	ksp_script_name_input = createInput("instrument");
		ksp_script_name_input.position(button_interval_x,button_interval_y*6);
		ksp_script_name_input.size(75);
		
	file_size_input = createInput("1000000");
		file_size_input.position((button_interval_x*7)+button_size_x+10,button_interval_y*13);
		file_size_input.size(100);

} // End Setup

/////////////////////////////////////////////////////////////////////////////////////////////

// Draw Function
function draw() {

	// Clear if needed
	clear();

	// Set canvas background
	background('#000000'); 

	stroke(55,55,55);
	strokeWeight(1);
	noFill();
	//rect(35, 40, 400, 85);

	stroke(55,55,55);
	strokeWeight(1);
	fill(250,250,250);

	// Main settings
	text("Kontakt Sample Library Tool",text_interval_x_2,15,250,text_box_size_y);

	text("Get SoX",text_interval_x_3,15,250,text_box_size_y);
	text("Get FLAC",text_interval_x_3*1.3,15,250,text_box_size_y);

	text("SoX Path Mac",text_interval_x_4,text_interval_y*2,250,text_box_size_y);
	text("SoX Path Win",text_interval_x_4,text_interval_y*3,250,text_box_size_y);
	text("FLAC Path Mac",text_interval_x_4,text_interval_y*4,250,text_box_size_y);
	text("FLAC Path Win",text_interval_x_4,text_interval_y*5,250,text_box_size_y);

	text("Download Framework",text_interval_x,text_interval_y*2,250,text_box_size_y);
	text("Documentation",text_interval_x*4.8,text_interval_y*2,250,text_box_size_y);
	text("Export Variables",text_interval_x*8,text_interval_y*2,250,text_box_size_y);
	text("Load Preset",text_interval_x_3,text_interval_y*2,250,text_box_size_y);
	text("Sample Path",text_interval_x,text_interval_y*3,250,text_box_size_y);
	text("Verbose Mode",text_interval_x_3,text_interval_y*3,250,text_box_size_y);
	
	// KSP Script
	// x row 1
	text("KSP Script",text_interval_x*3,text_interval_y*4,250,text_box_size_y);
	text("KSP Path",text_interval_x,text_interval_y*5,250,text_box_size_y);
	text("Name",text_interval_x,text_interval_y*6,250,text_box_size_y);
	text("Linked",text_interval_x*5,text_interval_y*6,250,text_box_size_y);
	text("Bypass",text_interval_x*7,text_interval_y*6,250,text_box_size_y);
	text("Slot",text_interval_x*9,text_interval_y*6,250,text_box_size_y);

	// Automapper
	// x row 1
	text("Auto Mapper",text_interval_x*3,text_interval_y*7,250,text_box_size_y);
	text("Reset Groups",text_interval_x,text_interval_y*8,250,text_box_size_y);
	text("Root Detect",text_interval_x,text_interval_y*9,250,text_box_size_y);
	text("Fix Tune",text_interval_x,text_interval_y*10,250,text_box_size_y);
	text("Root Key Loc",text_interval_x,text_interval_y*11,250,text_box_size_y);
		text(root_key_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*11,250,text_box_size_y);
	text("Low Key Loc",text_interval_x,text_interval_y*12,250,text_box_size_y);
		text(low_key_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*12,250,text_box_size_y);
	text("High Key Loc",text_interval_x,text_interval_y*13,250,text_box_size_y);
		text(high_key_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*13,250,text_box_size_y);
	text("Low Vel Loc",text_interval_x,text_interval_y*14,250,text_box_size_y);
		text(low_vel_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*14,250,text_box_size_y);
	text("High Vel Loc",text_interval_x,text_interval_y*15,250,text_box_size_y);
		text(high_vel_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*15,250,text_box_size_y);
	text("Sample Name Loc",text_interval_x,text_interval_y*16,250,text_box_size_y);
		text(sample_name_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*16,250,text_box_size_y);
	text("Signal Name Loc",text_interval_x,text_interval_y*17,250,text_box_size_y);
		text(signal_name_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*17,250,text_box_size_y);
	text("Articulation Loc",text_interval_x,text_interval_y*18,250,text_box_size_y);
		text(articulation_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*18,250,text_box_size_y);
	text("Round Robin Loc",text_interval_x,text_interval_y*19,250,text_box_size_y);
		text(round_robin_location_slider.value(),slider_interval_x+slider_text_offset,text_interval_y*19,250,text_box_size_y);
	
	// x row 2
	text("Key Confine",text_interval_x_2,text_interval_y*8,250,text_box_size_y);
	text("Vel Confine",text_interval_x_2,text_interval_y*9,250,text_box_size_y);
	text("Playback Mode",text_interval_x_2,text_interval_y*10,250,text_box_size_y);
	text("Token Separator",text_interval_x_2,text_interval_y*11,250,text_box_size_y);
	text("Def Root Key Val",text_interval_x_2,text_interval_y*12,250,text_box_size_y);
		text(default_root_key_value_slider.value(),(slider_interval_x*3)+slider_text_offset,text_interval_y*12,250,text_box_size_y);
	text("Def Low Key Val",text_interval_x_2,text_interval_y*13,250,text_box_size_y);
		text(default_low_key_value_slider.value(),(slider_interval_x*3)+slider_text_offset,text_interval_y*13,250,text_box_size_y);
	text("Def High Key Val",text_interval_x_2,text_interval_y*14,250,text_box_size_y);
		text(default_high_key_value_slider.value(),(slider_interval_x*3)+slider_text_offset,text_interval_y*14,250,text_box_size_y);
	text("Def Low Vel Val",text_interval_x_2,text_interval_y*15,250,text_box_size_y);
		text(default_low_vel_value_slider.value(),(slider_interval_x*3)+slider_text_offset,text_interval_y*15,250,text_box_size_y);
	text("Def High Vel Val",text_interval_x_2,text_interval_y*16,250,text_box_size_y);
		text(default_high_vel_value_slider.value(),(slider_interval_x*3)+slider_text_offset,text_interval_y*16,250,text_box_size_y);
	text("Set Loop",text_interval_x_2,text_interval_y*17,250,text_box_size_y);
	text("Loop Xfade",text_interval_x_2,text_interval_y*18,250,text_box_size_y);
		text(loop_xfade_slider.value(),(slider_interval_x*3)+slider_text_offset,text_interval_y*18,250,text_box_size_y);

	// Audio Tools
	// x row 3
	text("Audio Tools",text_interval_x_3*1.1,text_interval_y*7,250,text_box_size_y);
	text("Decode FLAC",text_interval_x_3,text_interval_y*8,250,text_box_size_y);
	text("HP Filter",text_interval_x_3,text_interval_y*9,250,text_box_size_y);
		text(hp_filter_slider.value(),(slider_interval_x*5)+(slider_text_offset+button_size_x),text_interval_y*9,250,text_box_size_y);
	text("Normalize",text_interval_x_3,text_interval_y*10,250,text_box_size_y);
		text(normalise_db_slider.value(),(slider_interval_x*5)+(slider_text_offset+button_size_x),text_interval_y*10,250,text_box_size_y);
	text("Reverse",text_interval_x_3,text_interval_y*11,250,text_box_size_y);
	text("Silence",text_interval_x_3,text_interval_y*12,250,text_box_size_y);
	text("Convert SR",text_interval_x_3,text_interval_y*13,250,text_box_size_y);
	text("Convert BD",text_interval_x_3,text_interval_y*14,250,text_box_size_y);
	text("Encode NCW",text_interval_x_3,text_interval_y*15,250,text_box_size_y);
	text("Encode FLAC",text_interval_x_3,text_interval_y*16,250,text_box_size_y);
	text("Encode OGG",text_interval_x_3,text_interval_y*17,250,text_box_size_y);

	// Sample Set Integrity
	// x row 4
	text("Sample Set Integrity",text_interval_x_4*1.1,text_interval_y*7,250,text_box_size_y);
	text("RMS",text_interval_x_4,text_interval_y*8,250,text_box_size_y);
		text(rms_check_slider.value(),(slider_interval_x*7)+(slider_text_offset+button_size_x),text_interval_y*8,250,text_box_size_y);
	text("Loudness",text_interval_x_4,text_interval_y*9,250,text_box_size_y);
		text(loudness_check_slider.value(),(slider_interval_x*7)+(slider_text_offset+button_size_x),text_interval_y*9,250,text_box_size_y);
	text("Peak",text_interval_x_4,text_interval_y*10,250,text_box_size_y);
		text(peak_check_slider.value(),(slider_interval_x*7)+(slider_text_offset+button_size_x),text_interval_y*10,250,text_box_size_y);
	text("Sample Rate",text_interval_x_4,text_interval_y*11,250,text_box_size_y);
	text("Bit Depth",text_interval_x_4,text_interval_y*12,250,text_box_size_y);
	text("File Size",text_interval_x_4,text_interval_y*13,250,text_box_size_y);
	text("Loop Exists",text_interval_x_4,text_interval_y*14,250,text_box_size_y);
	text("File Names",text_interval_x_4,text_interval_y*15,250,text_box_size_y);

	get_sox_button.draw();
	get_flac_button.draw();

	download_framework_button.draw();
	documentation_button.draw();
	export_button.draw();
	// samples_path_button.draw();
	verbose_mode_button.draw();
	
	ksp_script_set_button.draw();
	// ksp_script_path_button.draw();
	ksp_script_linked_button.draw();
	ksp_script_bypass_button.draw();

	auto_mapper_set_button.draw();
	reset_groups_button.draw();
	root_detect_button.draw();
	fix_tune_button.draw();
	key_confine_button.draw();
	vel_confine_button.draw();

	audio_tools_button.draw();
	decode_flac_button.draw();
	hp_filter_button.draw();
	normalise_button.draw();
	reverse_button.draw();
	silence_button.draw();
	convert_sr_button.draw();
	convert_bd_button.draw();
	encode_ncw_button.draw();
	encode_flac_button.draw();
	encode_ogg_button.draw();

	sample_set_integrity_button.draw();
	rms_check_button.draw();
	loudness_check_button.draw();
	peak_check_button.draw();
	sample_rate_check_button.draw();
	bit_depth_check_button.draw();
	file_size_check_button.draw();
	loop_exists_button.draw();
	file_names_check_button.draw();

} // End Draw

/////////////////////////////////////////////////////////////////////////////////////////////

function export_variables() {
	parameter_array[0] = samples_path_input.value();
	parameter_array[1] = verbose_mode_bool;
	parameter_array[2] = auto_mapper_set_bool;
	parameter_array[3] = reset_groups_bool;
	parameter_array[4] = playback_mode_select.value();
	parameter_array[5] = root_detect_bool;
	parameter_array[6] = root_key_location_slider.value();
	parameter_array[7] = low_key_location_slider.value();
	parameter_array[8] = high_key_location_slider.value();
	parameter_array[9] = low_vel_location_slider.value();
	parameter_array[10] = high_vel_location_slider.value();
	parameter_array[11] = sample_name_location_slider.value();
	parameter_array[12] = signal_name_location_slider.value();
	parameter_array[13] = articulation_location_slider.value();
	parameter_array[14] = round_robin_location_slider.value();
	parameter_array[15] = default_root_key_value_slider.value();
	parameter_array[16] = default_low_key_value_slider.value();
	parameter_array[17] = default_high_key_value_slider.value();
	parameter_array[18] = default_low_vel_value_slider.value();
	parameter_array[19] = default_high_vel_value_slider.value();
	parameter_array[20] = key_confine_bool;
	parameter_array[21] = vel_confine_bool;
	var temp_token;
	switch(token_separator_select.selected()) {
		case "-":
			temp_token = "([^-]+)";
			break;
		case "_":
			temp_token = "([^_]+)";
			break;
		default:
			temp_token = "([^-]+)";
		}
	parameter_array[22] = temp_token;
	parameter_array[23] = fix_tune_bool;
	var temp_loop;
	switch(set_loop_select.selected()) {
		case "Off":
			temp_loop = 0;
			break;
		case "Just Set":
			temp_loop = 1;
			break;
		case "From Sample":
			temp_loop = 2;
			break;
		case "Find Loop":
			temp_loop = 3;
			break;
		default:
			temp_loop = 0;
		}
	parameter_array[24] = temp_loop;
	parameter_array[25] = loop_xfade_slider.value();
	parameter_array[26] = audio_tools_bool;
	parameter_array[27] = decode_flac_bool;
	parameter_array[28] = hp_filter_bool;
	parameter_array[29] = hp_filter_slider.value();
	parameter_array[30] = normalise_bool;
	parameter_array[31] = normalise_db_slider.value();
	parameter_array[32] = reverse_bool;
	parameter_array[33] = silence_bool;
	parameter_array[34] = convert_sr_bool;
	parameter_array[35] = convert_sr_select.value();
	parameter_array[36] = convert_bd_bool;
	parameter_array[37] = convert_bd_select.value();
	parameter_array[38] = encode_ncw_bool;
	parameter_array[39] = encode_flac_bool;
	parameter_array[40] = encode_ogg_bool;
	parameter_array[41] = ksp_script_set_bool;
	parameter_array[42] = ksp_script_path_input.value();
	parameter_array[43] = ksp_script_linked_bool;
	parameter_array[44] = ksp_script_slot_select.value();
	parameter_array[45] = ksp_script_bypass_bool;
	var temp_string = ksp_script_name_input.value()
	if (temp_string === "") {
		temp_string = "instrument";
	}
	parameter_array[46] = temp_string;
	parameter_array[47] = sample_set_integrity_bool ;
	parameter_array[48] = rms_check_bool;
	parameter_array[49] = rms_check_slider.value();
	parameter_array[50] = loudness_check_bool;
	parameter_array[51] = loudness_check_slider.value();
	parameter_array[52] = peak_check_bool;
	parameter_array[53] = peak_check_slider.value();
	parameter_array[54] = sample_rate_check_bool;
	parameter_array[55] = sr_check_select.value();
	parameter_array[56] = bit_depth_check_bool;
	parameter_array[57] = bd_check_select.value();
	parameter_array[58] = file_size_check_bool;
	parameter_array[59] = file_size_input.value();
	parameter_array[60] = loop_exists_bool;
	parameter_array[61] = file_names_check_bool;
	parameter_array[62] = sox_path_mac_input.value();
	parameter_array[63] = sox_path_win_input.value();
	parameter_array[64] = flac_path_mac_input.value();
	parameter_array[65] = flac_path_win_input.value();

	save(parameter_array,"instrument_parameters.txt")
}

function handle_preset_file(file) {
	var preset_params = file.data.split("\n");
	samples_path_input.value(preset_params[0]);
	verbose_mode_bool = (preset_params[1] === "false");
	verbose_mode_button.onPress();
	auto_mapper_set_bool = (preset_params[2] === "false");
	auto_mapper_set_button.onPress();
	reset_groups_bool = (preset_params[3] === "false");
	reset_groups_button.onPress();
	playback_mode_select.selected(preset_params[4]);
	root_detect_bool = (preset_params[5] === "false");
	root_detect_button.onPress();
	root_key_location_slider.value(preset_params[6]);
	low_key_location_slider.value(preset_params[7]);
	high_key_location_slider.value(preset_params[8]);
	low_vel_location_slider.value(preset_params[9]);
	high_vel_location_slider.value(preset_params[10]);
	sample_name_location_slider.value(preset_params[11]);
	signal_name_location_slider.value(preset_params[12]);
	articulation_location_slider.value(preset_params[13]);
	round_robin_location_slider.value(preset_params[14]);
	default_root_key_value_slider.value(preset_params[15]);
	default_low_key_value_slider.value(preset_params[16]);
	default_high_key_value_slider.value(preset_params[17]);
	default_low_vel_value_slider.value(preset_params[18]);
	default_high_vel_value_slider.value(preset_params[19]);
	key_confine_bool = (preset_params[20] === "false");
	key_confine_button.onPress();
	vel_confine_bool = (preset_params[21] === "false");
	vel_confine_button.onPress();
	switch(preset_params[22]) {
		case "([^-]+)":
			token_separator_select.selected("-");
			break;
		case "([^_]+)":
			token_separator_select.selected("_");
			break;
		}
	fix_tune_bool = (preset_params[23] === "false");
	fix_tune_button.onPress();
	switch(preset_params[24]) {
		case "0":
			set_loop_select.selected("Off");
			break;
		case "1":
			set_loop_select.selected("Just Set");
			break;
		case "2":
			set_loop_select.selected("From Sample");
			break;
		case "3":
			set_loop_select.selected("Find Loop");
			break;
		}
		loop_xfade_slider.value(preset_params[25]);
		audio_tools_bool = (preset_params[26] === "false");
		audio_tools_button.onPress();
		decode_flac_bool = (preset_params[27] === "false");
		decode_flac_button.onPress();
		hp_filter_bool = (preset_params[28] === "false");
		hp_filter_button.onPress();
		hp_filter_slider.value(preset_params[29]);
		normalise_bool = (preset_params[30] === "false");
		normalise_button.onPress();
		normalise_db_slider.value(preset_params[31]);
		reverse_bool = (preset_params[32] === "false");
		reverse_button.onPress();
		silence_bool = (preset_params[33] === "false");
		silence_button.onPress();
		convert_sr_bool = (preset_params[34] === "false");
		convert_sr_button.onPress();
		convert_sr_select.selected(preset_params[35]);
		convert_bd_bool = (preset_params[36] === "false");
		convert_bd_button.onPress();
		convert_bd_select.selected(preset_params[37]);
		encode_ncw_bool = (preset_params[28] === "false");
		encode_ncw_button.onPress();
		encode_flac_bool = (preset_params[39] === "false");
		encode_flac_button.onPress();
		encode_ogg_bool = (preset_params[40] === "false");
		encode_ogg_button.onPress();
		ksp_script_set_bool = (preset_params[41] === "false");
		ksp_script_set_button.onPress();
		ksp_script_path_input.value(preset_params[42]);
		ksp_script_linked_bool = (preset_params[43] === "false");
		ksp_script_linked_button.onPress();
		ksp_script_slot_select.selected(preset_params[44]);
		ksp_script_bypass_bool = (preset_params[45] === "false");
		ksp_script_bypass_button.onPress();
		ksp_script_name_input.value(preset_params[46]);
		sample_set_integrity_bool = (preset_params[47] === "false");
		sample_set_integrity_button.onPress();
		rms_check_bool = (preset_params[48] === "false");
		rms_check_button.onPress();
		rms_check_slider.value(preset_params[49]);
		loudness_check_bool = (preset_params[50] === "false");
		loudness_check_button.onPress();
		loudness_check_slider.value(preset_params[51]);
		peak_check_bool = (preset_params[52] === "false");
		peak_check_button.onPress();
		peak_check_slider.value(preset_params[53]);
		sample_rate_check_bool = (preset_params[54] === "false");
		sample_rate_check_button.onPress();
		sr_check_select.selected(preset_params[55]);
		bit_depth_check_bool = (preset_params[56] === "false");
		bit_depth_check_button.onPress();
		bd_check_select.selected(preset_params[57]);
		file_size_check_bool = (preset_params[58] === "false");
		file_size_check_button.onPress();
		file_size_input.value(preset_params[59]);
		loop_exists_bool = (preset_params[60] === "false");
		loop_exists_button.onPress();
		file_names_check_bool = (preset_params[61] === "false");
		file_names_check_button.onPress();
		sox_path_mac_input.value(preset_params[62]);
		sox_path_win_input.value(preset_params[63]);
		flac_path_mac_input.value(preset_params[64]);
		flac_path_win_input.value(preset_params[65]);

}

function sleep(ms) {
	return new Promise(resolve => setTimeout(resolve, ms));
}

// End Script