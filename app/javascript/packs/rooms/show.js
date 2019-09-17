import Vue from 'vue/dist/vue.esm';
import axios from 'axios';
axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
import Switch from '../components/switch.vue';
import Notice from '../components/notice.vue';
import Alert from '../components/alert.vue';
import Info from '../components/info.vue';
import Timer from '../components/timer.vue';
import Post from '../components/post.vue';

new Vue({
  el: '#room-root',
  data: {
    chatDisplay: true,
    inputDisplay: true,
    noticeDisplay: false,
    noticeMessage: "",
    alertDisplay: false,
    alertMessage: "",
    infoDisplay: false,
    infoMessages: [],
    villageId: villageId,
    villageStatus: villageStatus,
    initialRemainingTime: 5,
    recordId: record ? record.id : "",
    voteSelected: record ? record.vote_target_id : "",
    attackSelected: record ? record.attack_target_id : "",
    divineSelected: record ? record.divine_target_id : "",
    guardSelected: record ? record.guard_target_id : "",
    posts: [],
    haveAllPosts: true,
    playerFilter: "all",
    roomId: roomId,
    channel: null,
    chatMessage: "",
    scrollFlag: true
  },
  created: function() {
    this.subscribeChannel()
    this.getPosts()
    if(this.villageStatus === "in_play") {
      this.setInitialRemainingTime()
      this.setIntervalRemainingTime()
    }
  },
  watch: {
    posts: function() {
      if(this.scrollFlag) {
        this.$nextTick(function () {
          this.scrollDown()
        })
      }
    },
    playerFilter: function() {
      this.$nextTick(function () {
        this.scrollDown()
      })
    }
  },
  methods: {
    setVoteTarget: function() {
      axios.put('/api/v1/records/' + this.recordId + '/vote', { record: { vote_target_id: this.voteSelected } })
        .then(res => {
          this.setNotice("投票先をセットしました")
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    setAttackTarget: function() {
      axios.put('/api/v1/records/' + this.recordId + '/attack', { record: { attack_target_id: this.attackSelected } })
        .then(res => {
          this.setNotice("襲撃先をセットしました")
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    setDivineTarget: function() {
      axios.put('/api/v1/records/' + this.recordId + '/divine', { record: { divine_target_id: this.divineSelected } })
        .then(res => {
          this.setNotice("占い先をセットしました")
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    setGuardTarget: function() {
      axios.put('/api/v1/records/' + this.recordId + '/guard', { record: { guard_target_id: this.guardSelected } })
        .then(res => {
          this.setNotice("護衛先をセットしました")
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    switchArea: function() {
      this.chatDisplay = !this.chatDisplay
    },
    switchInput: function() {
      this.inputDisplay = !this.inputDisplay
    },
    setNotice: function(message) {
      this.noticeDisplay = true
      this.noticeMessage = message
    },
    setAlert: function(message) {
      this.alertDisplay = true
      this.alertMessage = message
    },
    setInfo: function(messages) {
      this.infoDisplay = true
      this.infoMessages = messages
    },
    resetMessage: function() {
      this.noticeDisplay = false
      this.alertDisplay = false
      this.infoDisplay = false
    },
    setIntervalRemainingTime: function() {
      setInterval(this.setInitialRemainingTime, 30000)
    },
    setInitialRemainingTime: function() {
      axios.get('/api/v1/villages/' + this.villageId + '/remaining_time')
        .then(res => {
          this.initialRemainingTime = res.data.remaining_time
        });
    },
    showDivineResult: function() {
      axios.get('/api/v1/villages/' + this.villageId + '/divine')
        .then(res => {
          this.setInfo(res.data.messages)
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    showVoteResult: function() {
      axios.get('/api/v1/villages/' + this.villageId + '/see_soul')
        .then(res => {
          this.setInfo(res.data.messages)
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    getPosts: function() {
      axios.get('/api/v1/rooms/' + this.roomId + '/posts')
        .then(res => {
          this.posts = res.data
          if(this.posts.length == 20) {
            this.haveAllPosts = false
          }
        });
    },
    getAllPosts: function() {
      this.posts = []
      axios.get('/api/v1/rooms/' + this.roomId + '/all_posts')
        .then(res => {
          this.posts = res.data
        });
      this.haveAllPosts = true
    },
    subscribeChannel: function() {
      this.channel = App.cable.subscriptions.create(
        { channel: 'RoomChannel', room_id: this.roomId },
        { received: this.receiveMessage }
      );
    },
    receiveMessage: function(data) {
      if(data['reload']) {
        location.reload(true)
      } else if(data['message']) {
        var message = JSON.parse(data['message'])
        // If the current position is at the bottom, scroll down
        this.scrollFlag = this.confirmExecuteScroll()
        this.posts.push(message)
      }
    },
    speakMessage: function() {
      if(this.chatMessage) {
        this.channel.perform('speak', {message: this.chatMessage})
        this.chatMessage = ""
      }
    },
    scrollDown: function() {
      let el = this.$el.getElementsByClassName("chat-body")[0]
      el.scrollTop = el.scrollHeight
    },
    confirmExecuteScroll: function() {
      let el = this.$el.getElementsByClassName("chat-body")[0]
      var scrollAvailable = el.scrollHeight - el.offsetHeight
      if(el.scrollTop == scrollAvailable) {
        return true
      } else {
        return false
      }
    }
  },
  components: {
    'switch-component': Switch,
    'notice-component': Notice,
    'info-component': Info,
    'alert-component': Alert,
    'timer-component': Timer,
    'post-component': Post
  }
});
