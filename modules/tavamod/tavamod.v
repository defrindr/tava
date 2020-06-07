module tavamod

import net.http
import time
import os

const (
	base_url = 'https://t.me/'
)

/**
 * get_username
 * request from http
 *
 * @param user string
 * @return     string
 **/
fn get_username(user string) string {
	html_resp := http.get(base_url + user) or {
		println('[  XX  ] Failed get data, prepare to trying again ...')
		return get_username(user)
	}
	return html_resp.text
}


/**
 * is_exist
 * check exist or not , telegram account
 *
 * @param user string
 * @return     bool
 **/
fn is_exist(user string) bool {
	source := get_username(user)
	len_source := source.split('tgme_page_title').len
	if len_source > 1 {
		return true
	}
	return false
}

/**
 * generate_dir_name
 * generating name from date
 *
 * @return name string
 **/
fn generate_dir_name() string {
	name := time.now().str().split(' ')[0] + '_result'
	return name
}

/**
 * mkdir
 * simplify os.mkdir function
 *
 * @param name string
 * @return path string
 **/
fn mkdir(name string) string {
	relative_path := generate_dir_name()
	full_path := '$relative_path/$name'

	if !os.exists(relative_path) {
		os.mkdir(relative_path)
	}
	if !os.exists(full_path) {
		os.mkdir(full_path)
	}

	return full_path
}

/**
 * remove_ext
 * removing extension from name
 * @param name string
 * @return name_list string
 **/
fn remove_ext(name string) string {
	mut name_slicing := name.split('.')
	name_len := name_slicing.len
	name_list := name_slicing[0..name_len - 1].join('')

	return name_list
}


/**
 * save_file
 * simplify os.write_file function
 *
 * @param source_list string
 * @param name string
 * @param content string
 * @return full_path string
 **/
fn save_file(source_list string, name string, content string) string {
	mut name_list := remove_ext(source_list)
	dir_path := mkdir(name_list)

	full_path := '$dir_path/$name'

	os.write_file(full_path, content)

	return full_path
}

/**
 * check
 * This is main function in tavamod
 *
 * @param source_list string
 **/
pub fn check(source_list string) {
	println('[ TAVA ] Running ....')
	mut file := os.read_file(source_list) or {
		panic('Error when trying to open file.')
	}
	accounts := file.split('\n')
	
	mut valid := ''
	mut notvalid := ''

	println('[ TAVA ] Checking Account ....')
	
	for account in accounts {
		mut is_exist := is_exist(account)
		if is_exist {
			valid += '$account\n'
		} else {
			notvalid += '$account\n'
		}
	}

	println('[ TAVA ] Writing Results ....')

	valid_path := save_file(source_list, 'valid.txt', valid)
	println('[  ++  ] Storing valid account to $valid_path')
	
	save_file(source_list, 'invalid.txt', notvalid)
	println('[  ++  ] Storing invalid account to $valid_path')
	
	println('[ TAVA ] Complete ....')
}
