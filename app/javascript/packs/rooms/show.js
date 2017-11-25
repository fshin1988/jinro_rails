import Vue from 'vue/dist/vue.esm';
import axios from 'axios';
axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')

var switchComponent = Vue.extend({
    template: '<button v-on:click="emitSwitch">切り替え</button>',
    methods: {
      emitSwitch: function() {
        this.$emit('switch')
      }
    }
});

var noticeComponent = Vue.extend({
    props: ['noticeMessage'],
    template: '\
      <div class="alert alert-success">\
        <button type="button" class="close" data-dismiss="alert" aria-label="Close" v-on:click="emitReset">\
          <span aria-hidden="true">&times;</span>\
        </button>\
        {{noticeMessage}}\
      </div>\
    ',
    methods: {
      emitReset: function() {
        this.$emit('reset')
      }
    }
});

new Vue({
  el: '#room-root',
  data: {
    chatDisplay: true,
    noticeDisplay: false,
    noticeMessage: "",
    voteSelected: "",
    attackSelected: "",
    divineSelected: "",
    guardSelected: ""
  },
  created: function() {
    this.setInitialValue()
  },
  methods: {
    setVoteTarget(id) {
      axios.put('/api/v1/records/' + id, { record: { vote_target_id: this.voteSelected } })
        .then(res => {
          this.setNotice("投票先をセットしました")
        }, (error) => {
          this.setError("エラーが発生しました")
        });
    },
    setAttackTarget(id) {
      axios.put('/api/v1/records/' + id, { record: { attack_target_id: this.attackSelected } })
        .then(res => {
          this.setNotice("襲撃先をセットしました")
        });
    },
    setDivineTarget(id) {
      axios.put('/api/v1/records/' + id, { record: { divine_target_id: this.divineSelected } })
        .then(res => {
          this.setNotice("占い先をセットしました")
        });
    },
    setGuardTarget(id) {
      axios.put('/api/v1/records/' + id, { record: { guard_target_id: this.guardSelected } })
        .then(res => {
          this.setNotice("護衛先をセットしました")
        });
    },
    switchArea: function() {
      this.chatDisplay = !this.chatDisplay
    },
    resetNotice: function() {
      this.noticeDisplay = false
    },
    setNotice: function(message) {
      this.noticeDisplay = true
      this.noticeMessage = message
    },
    setInitialValue: function() {
      this.voteSelected = document.getElementById('vote-initial').getAttribute('initial')
      this.attackSelected = document.getElementById('attack-initial').getAttribute('initial')
      this.divineSelected = document.getElementById('divine-initial').getAttribute('initial')
      this.guardSelected = document.getElementById('guard-initial').getAttribute('initial')
    }
  },
  components: {
    'switch-component': switchComponent,
    'notice-component': noticeComponent
  }
});
