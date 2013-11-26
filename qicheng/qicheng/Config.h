//
//  Config.h
//  qicheng
//
//  Created by tony on 13-11-19.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#ifndef qicheng_Config_h
#define qicheng_Config_h

#define PROTOCOL_RECV_HEAD                      @"!"
#define PROTOCOL_RECV_TAIL                      @"#"
#define PROTOCOL_SEND_HEAD       				@"$"
#define RPOTOCOL_SEND_TAIL       				@"#"

#define COUNT_ALARM								(4)
#define COUNT_RELAY								(8)
#define COUNT_SENSOR							(4)

#define LENGTH_CLOSE_CURTAIN					(1)
#define LENGTH_DATA_LENGTH  					(2)
#define LENGTH_FUNCTION_NAME    				(1)
#define LENGTH_MODULE_ADDR  					(2)
#define LENGTH_OPEN_CURTAIN						(1)
#define LENGTH_STOP_CURTAIN						(1)
#define LENGTH_QUERY_ALARM_IS_OPEN				(2)
#define LENGTH_QUERY_ALL_ALARM_COUNT			(16)
#define LENGTH_QUERY_ALL_RELAY_STATUS			(2)
#define LENGTH_QUERY_ALL_SENSOR_STATUS			(2)
#define LENGTH_QUERY_ALL_TIMER_STATUS			(long)
#define LENGTH_QUERY_SYS_DATETIME				(14)

#define FUNCTION_INDEX_CLOSE_CURTAIN			'g'
#define FUNCTION_INDEX_CLOSE_RELAY              'b'
#define FUNCTION_INDEX_INCORRECT_INSTRUCTION 	'r'
#define FUNCTION_INDEX_INCORRECT_PASSWORD    	'o'
#define FUNCTION_INDEX_OPEN_CURTAIN				'e'
#define FUNCTION_INDEX_OPEN_RELAY               'a'
#define FUNCTION_INDEX_STOP_CURTAIN				'f'
#define FUNCTION_INDEX_QUERY_ALARM_IS_OPEN		'y'
#define FUNCTION_INDEX_QUERY_ALL_ALARM_COUNT	'x'
#define FUNCTION_INDEX_QUERY_ALL_RELAY_STATUS	'd'
#define FUNCTION_INDEX_QUERY_ALL_SENSOR_STATUS	'w'
#define FUNCTION_INDEX_QUERY_ALL_TIMER_STATUS	'v'
#define FUNCTION_INDEX_QUERY_SYS_DATETIME		's'

#define FUNCTION_NAME_CLOSE_CURTAIN				@"g"
#define FUNCTION_NAME_CLOSE_RELAY               @"b"
#define FUNCTION_NAME_INCORRECT_INSTRUCTION 	@"r"
#define FUNCTION_NAME_INCORRECT_PASSWORD    	@"o"
#define FUNCTION_NAME_OPEN_CURTAIN				@"e"
#define FUNCTION_NAME_OPEN_RELAY                @"a"
#define FUNCTION_NAME_STOP_CURTAIN				@"f"
#define FUNCTION_NAME_QUERY_ALARM_IS_OPEN		@"y"
#define FUNCTION_NAME_QUERY_ALL_ALARM_COUNT		@"x"
#define FUNCTION_NAME_QUERY_ALL_RELAY_STATUS	@"d"
#define FUNCTION_NAME_QUERY_ALL_SENSOR_STATUS	@"w"
#define FUNCTION_NAME_QUERY_ALL_TIMER_STATUS	@"v"
#define FUNCTION_NAME_QUERY_SYS_DATETIME		@"s"

#endif
