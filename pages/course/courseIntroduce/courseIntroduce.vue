<template>
	<view class="home">
		<view class="courseIntroduce_box">
			<view class="courseIntroduce_des">
				<view class="courseIntroduce_info">{{ introduce }}</view>
			</view>
			<CourseIntrduceData :msg="introduceList"/>
			<view class="courseIntroduce_tab_box">
				<view class="courseIntroduce_tab_nav">
					<view :class="{'btna':count===index}" @click="changeTab(index)" v-for="(item,index) in items" :key="index">{{item}}</view>
				</view>
				<view class="courseIntroduce_tab_con">
					<view class="discount_info" :class="{'dis':count===0}">
						<CourseList :Clist="Clist"/>
					</view>
					<view class="discount_info" :class="{'dis':count===1}">
						<CourseJieshao :imageT="imageT" :imageHeight="imageHeight"/>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	
	
	import { request } from "../../../common/api.js"
import CourseIntrduceData from "../../../components/couser-intrduce-data/couser-intrduce-data.vue"
	import CourseList from "../../../components/course-list/course-list.vue"
	import CourseJieshao from "../../../components/course-jieshao/course-jieshao.vue"
	export default {
		data() {
			return {
				introduce:"",
				introduceList:[],
				items:["课程章节","课程介绍"],
				count:0,
				Clist:[],
				imageT:"",
				imageHeight:""
			}
		},
		components:{
			CourseIntrduceData,
			CourseList,
			CourseJieshao
		},
		// 小程序提供的方法
		onLoad(options){
			request({
				url:"/api/course/detail",
				data:{
					id:options.id,
					course:options.course
				},
				success:res =>{
					this.introduce = res.data.data.introduce
					this.introduceList = res.data.data.introduceList
					this.Clist = res.data.data.Clist
					this.imageT = res.data.data.image
					this.imageHeight = res.data.data.height
				}
			})	
		},
		methods: {
			changeTab(index){
				this.count = index
			}
		}
	}
</script>

<style lang="scss">
	
	.courseIntroduce_box {
			display: flex;
			box-sizing: box;
			flex-direction: column;
			margin-bottom: 90px;
	
			.courseIntroduce_des {
				display: flex;
				box-sizing: border-box;
				flex-direction: column;
				justify-content: center;
				align-items: center;
				width: 100%;
				background-color: #0c9c8f;
				padding: 0 10px 15px;
				overflow: hidden;
	
				.courseIntroduce_info {
					display: flex;
					box-sizing: box;
					width: 100%;
					color: #fff;
					font-size: 16px;
					line-height: 24px;
				}
			}
	
			//tab
			.courseIntroduce_tab_box {
				display: flex;
				box-sizing: border-box;
				flex-direction: column;
	
				.courseIntroduce_tab_nav {
					display: flex;
					box-sizing: border-box;
					flex-direction: row;
					background-color: #fff;
					border-bottom: 1px solid #e4e4e4;
					margin-bottom: 20px;
	
					view {
						height: 50px;
						line-height: 50px;
						font-size: 16px;
						flex-grow: 1;
						text-align: center;
						background-color: #fff;
	
					}
				}
	
				.discount_info {
					display: none;
				}
	
				.btna {
					display: flex;
					box-sizing: border-box;
					justify-content: center; //水平方向对齐
					color: #00b783;
					position: relative;
				}
	
				.btna::after {
					content: '';
					width: 40px;
					height: 3px;
					background-color:#00b783;
					position: absolute;
					bottom: 0;
					left: 50%;
					margin-left: -20px;
				}
	
				.dis {
					display: block;
				}
			}
		}

</style>
