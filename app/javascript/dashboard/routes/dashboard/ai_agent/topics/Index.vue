<script setup>
import { computed, onMounted, ref, nextTick } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';

import TopicCard from 'dashboard/components-next/captain/topic/TopicCard.vue';
import DeleteDialog from 'dashboard/components-next/captain/pageComponents/DeleteDialog.vue';
import PageLayout from 'dashboard/components-next/captain/PageLayout.vue';
import CaptainPaywall from 'dashboard/components-next/captain/pageComponents/Paywall.vue';
import CreateTopicDialog from 'dashboard/components-next/captain/pageComponents/topic/CreateTopicDialog.vue';
import TopicPageEmptyState from 'dashboard/components-next/captain/pageComponents/emptyStates/TopicPageEmptyState.vue';
import FeatureSpotlightPopover from 'dashboard/components-next/feature-spotlight/FeatureSpotlightPopover.vue';
import LimitBanner from 'dashboard/components-next/captain/pageComponents/response/LimitBanner.vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const store = useStore();
const dialogType = ref('');
const uiFlags = useMapGetter('captainTopics/getUIFlags');
const topics = useMapGetter('captainTopics/getRecords');
const isFetching = computed(() => uiFlags.value.fetchingList);

const selectedTopic = ref(null);
const deleteTopicDialog = ref(null);

const handleDelete = () => {
  deleteTopicDialog.value.dialogRef.open();
};

const createTopicDialog = ref(null);

const handleCreate = () => {
  dialogType.value = 'create';
  nextTick(() => createTopicDialog.value.dialogRef.open());
};

const handleEdit = () => {
  router.push({
    name: 'captain_topics_edit',
    params: { topicId: selectedTopic.value.id },
  });
};

const handleViewConnectedInboxes = () => {
  router.push({
    name: 'captain_topics_inboxes_index',
    params: { topicId: selectedTopic.value.id },
  });
};

const handleAction = ({ action, id }) => {
  selectedTopic.value = topics.value.find(
    topic => id === topic.id
  );
  nextTick(() => {
    if (action === 'delete') {
      handleDelete();
    }
    if (action === 'edit') {
      handleEdit();
    }
    if (action === 'viewConnectedInboxes') {
      handleViewConnectedInboxes();
    }
  });
};

const handleCreateClose = () => {
  dialogType.value = '';
  selectedTopic.value = null;
};

onMounted(() => store.dispatch('captainTopics/get'));
</script>

<template>
  <PageLayout
    :header-title="$t('CAPTAIN.TOPICS.HEADER')"
    :button-label="$t('CAPTAIN.TOPICS.ADD_NEW')"
    :button-policy="['administrator']"
    :show-pagination-footer="false"
    :is-fetching="isFetching"
    :is-empty="!topics.length"
    :feature-flag="FEATURE_FLAGS.CAPTAIN"
    @click="handleCreate"
  >
    <template #knowMore>
      <FeatureSpotlightPopover
        :button-label="$t('CAPTAIN.HEADER_KNOW_MORE')"
        :title="$t('CAPTAIN.TOPICS.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
        :note="$t('CAPTAIN.TOPICS.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
        fallback-thumbnail="/assets/images/dashboard/captain/topic-popover-light.svg"
        fallback-thumbnail-dark="/assets/images/dashboard/captain/topic-popover-dark.svg"
        learn-more-url="https://chwt.app/captain-topic"
      />
    </template>
    <template #emptyState>
      <TopicPageEmptyState @click="handleCreate" />
    </template>

    <template #paywall>
      <CaptainPaywall />
    </template>

    <template #body>
      <LimitBanner class="mb-5" />

      <div class="flex flex-col gap-4">
        <TopicCard
          v-for="topic in topics"
          :id="topic.id"
          :key="topic.id"
          :name="topic.name"
          :description="topic.description"
          :updated-at="topic.updated_at || topic.created_at"
          :created-at="topic.created_at"
          @action="handleAction"
        />
      </div>
    </template>

    <DeleteDialog
      v-if="selectedTopic"
      ref="deleteTopicDialog"
      :entity="selectedTopic"
      type="Topics"
    />

    <CreateTopicDialog
      v-if="dialogType"
      ref="createTopicDialog"
      :type="dialogType"
      :selected-topic="selectedTopic"
      @close="handleCreateClose"
    />
  </PageLayout>
</template>
