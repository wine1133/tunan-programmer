<template>
	<view class="course_list_box">
		<view class="course_list_con">
			<view class="course_list_info" @click="clickPlayer" v-for="(item,index) in Clist" :key="index">
				<view class="course_list_info_txt">{{item.type_name}}</view>
			</view>
		</view>
	</view>
</template>

<script>
	export default{
		data(){
			return{
				
			}
		},
		props:{
			Clist:{
				type:Array,
				default:function(){
					return []
				}
			}
		},
		methods:{
			clickPlayer(){
				uni.navigateTo({
					url:"/pages/course/player/player"
				})
			}
		}
	}
</script>

<style lang="scss">
	.course_list_box {
		display: flex;
		box-sizing: border-box;
		flex-direction: column;
		width: 100%;
		padding: 0 15px;

		.course_list_con {
			display: flex;
			box-sizing: border-box;
			flex-direction: column;
			flex-grow: 1;

			.course_list_info {
				display: flex;
				box-sizing: border-box;
				flex-direction: center;
				overflow: hidden;
				flex: 1;
				width: 100%;
				height: 45px;
				line-height: 45px;
				font-size: 14px;
				border-bottom: 1px solid #efefef;

				.course_list_info_txt {
					white-space: nowrap;
					overflow: hidden;
					text-overflow: ellipsis;
				}
			}
		}
	}
</style>
