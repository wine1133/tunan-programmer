<template>
	<view class="course_jieshao_box">
		<image :src="imageT" mode="" :style="{height:imageHeight+'rpx'}"></image>
	</view>
</template>

<script>
	export default{
		props:{
			imageT:{
				type:String,
				default:""
			},
			imageHeight:{
				type:String,
				default:""
			}
		}
	}
</script>

<style lang="scss">
	.course_jieshao_box{
		display: flex;
		box-sizing: box;
		flex-direction: column;
		justify-content: center;
		width: 100%;
		image{
			width: 750rpx;
			
		}
	}
</style>