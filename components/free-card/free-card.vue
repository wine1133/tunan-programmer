<template>
	<view class="free-container">
		<view class="free-card-box" v-for="(item,index) in teaList" :key="index">
			<view class="free-card-img">
				<image :src="item.teacher_logo" mode=""></image>
			</view>
			<view class="free-card-txt">
				<view class="free-card-t">{{item.limitName}}</view>
				<view class="free-card-info">
					<view class="free-card-info-txt">
						<view class="info-txt1">{{item.teacher_name}}{{item.teacher_job}}</view>
						<view>{{item.limitNum}}人学过</view>
					</view>
					<view class="free-card-info-btn">{{item.baoming}}</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	
	
	import { request } from "../../common/api.js"
export default{
		data(){
			return{
				teaList:[]
			}
		},
		mounted(){
			request({
				url:'/api/index/specific?userid=2162',
				success:res =>{
					this.teaList = res.data.data
				}
			})
		}
	}
	
	
</script>

<style lang="scss">
	
	.free-card-box{
		display: flex;
		padding: 10px 0;
		margin: 10px;
		border-radius: 10px;
		box-shadow: 0 0 5px 1px rgba(0,0,0,0.1);
		align-items: center;
		margin-bottom: 15px;
		background-color: #fff;
		.free-card-img{
			flex-shrink: 0;
			width: 91rpx;
			height: 91rpx;
			border-radius: 50%;
			margin: 0 15px;
			image{
				width: 100%;
				height: 100%;
				border-radius: 100%;
			}
		}
		.free-card-txt{
			width: 100%;
			display: flex;
			flex-direction: column;
			padding: 0 15px 0 0;
			.free-card-t{
				font-size: 16px;
				margin: 10px 0;
				white-space: nowrap;
				text-overflow: ellipsis;
				overflow: hidden;
			}
			.free-card-info{
				width: 100%;
				display: flex;
				flex-flow: row nowrap;
				justify-content: space-between;
				.free-card-info-txt{
					width: 60%;
					overflow: hidden;
					font-size: 16px;
					color: #666;
					.info-txt1{
						height: 20px;
						font-size: 14px;
						overflow: hidden;
					}
				}
			}
			.free-card-info-btn{
				width: 100px;
				height: 34px;
				text-align: center;
				line-height: 34px;
				background-color: #00b783;
				border-radius: 34px;
				color: #fff;
				font-size: 16px;
				margin-top: 10px;
			}
		}
	}
	
</style>
